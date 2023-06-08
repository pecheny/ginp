package;

import ginp.AxisToButton;
import ginp.GameAxes;
import ginp.GameButtons;
import ginp.GameInput;
import ginp.OnScreenStick;
import openfl.display.Sprite;
import openfl.ui.Keyboard;
import utils.AbstractEngine;
import utils.Updatable;

@:build(macros.BuildMacro.buildAxes())
@:enum abstract TGAxis(Axis<TGAxis>) to Axis<TGAxis> {
    var h;
    var v;
}

@:build(macros.BuildMacro.buildAxes())
@:enum abstract TGButts(Axis<TGButts>) to Axis<TGButts> {
    var jump = 0;
    var l;
    var r;
}

class InputTest extends AbstractEngine {
    var input:GameInput<TGAxis, TGButts>;

    public function new() {
        super();
        var wnd = openfl.Lib.application.window;
        if (wnd.y < 0)
            wnd.y = 20;
        input = new GameInput(TGButts.aliases.length, TGAxis.aliases.length);
        input.createKeyMapping([
            Keyboard.A => TGButts.l,
            Keyboard.D => TGButts.r,
            Keyboard.SPACE => TGButts.jump,
            Keyboard.LEFT => TGButts.l,
            Keyboard.RIGHT => TGButts.r,
            Keyboard.UP => TGButts.jump,
        ]);

        var faxes = input.addFakeAxis([Keyboard.J, Keyboard.L, Keyboard.K, Keyboard.I,]);

        var stick = input.createStick();
        var mapper = input.mapAxisSource(stick).withMapped(Axis2D.horizontal, TGAxis.h).withMapped(Axis2D.vertical, TGAxis.v);

        var a2b = new AxisToButton<Axis2D, TGButts>(Axis2D.aliases.length, stick, @:privateAccess input._buttons);

        var rend = new DummyOflStickRenderer(stick);
        addUpdatable(rend);
        addChild(rend);

        var x = 20;
        var y = 20;
        createButtonVeiw(TGButts.l, x += 40, y);
        createButtonVeiw(TGButts.jump, x += 40, y);
        createButtonVeiw(TGButts.r, x += 40, y);

        y += 40;
        x = 20;
        createAxisView(faxes, TGAxis.h, x, y += 40);
        createAxisView(faxes, TGAxis.v, x, y += 40);

        y -= 80;
        x += 140;

        createAxisView(mapper, TGAxis.h, x, y += 40);
        createAxisView(mapper, TGAxis.v, x, y += 40);

        y -= 80;
        x += 140;
        createAxisView(input.axes, TGAxis.h, x, y += 40);
        createAxisView(input.axes, TGAxis.v, x, y += 40);
    }

    function createAxisView(axes, a, x, y) {
        var av = new AxisView(axes, a);
        av.x = x;
        av.y = y;
        addChild(av);
        addUpdatable(av);
    }

    function createButtonVeiw(b, x, y) {
        var v = new GButtonView(input.buttons, b);
        addChild(v);
        v.x = x;
        v.y = y;
        addUpdatable(v);
    }

    override function update(t:Float) {
        input.beforeUpdate(t);
        super.update(t);
        input.afterUpdate();
    }
}

class GButtonView<B:Axis<B>> implements Updatable extends Sprite {
    var input:GameButtons<B>;
    var button:B;

    public function new(i, a) {
        super();
        this.button = a;
        this.input = i;
    }

    public function update(dt) {
        graphics.clear();
        var w = 30;
        var color = if (input.justPressed(button)) 0xff0000 else if (input.pressed(button)) 0xa03030 else 0x909090;
        graphics.beginFill(color);
        graphics.drawRect(0, 0, w, w);
        graphics.endFill();
    }
}

class AxisView<A:Axis<A>> implements Updatable extends Sprite {
    var input:GameAxes<A>;
    var axis:A;

    public function new(i, a) {
        super();
        this.axis = a;
        this.input = i;
    }

    public function update(dt) {
        graphics.clear();
        var w = 100;
        graphics.beginFill(0);
        graphics.drawRect(0, 0, w, 2);
        var mw = 4;
        graphics.beginFill(0xff0000);
        var pos = input.getDirProjection(axis) / 2 * w + w / 2;
        graphics.drawRect(pos - mw / 2, 0, mw, 8);
        graphics.endFill();
    }
}
