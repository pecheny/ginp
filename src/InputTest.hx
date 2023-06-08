package;

import ginp.AxisDispatcher;
import ginp.OnScreenStick;
import openfl.Lib;
import openfl.OflKbd;
import ginp.api.KbdListener.KeyCode;
import ginp.AxisToButton;
import ginp.OnScreenStick.AxisMapper;
import macros.AVConstructor;
import ginp.OnScreenStick.DummyOflStickAdapter;
import ginp.GameAxes;
import openfl.ui.Keyboard;
import ginp.GameKeys;
import ginp.GameButtons;
import utils.AbstractEngine;
import utils.Updatable;
import openfl.display.Sprite;

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

class GameInput<TAxis:Axis<TAxis>, TButton:Axis<TButton>> {
    var _buttons:GameButtonsImpl<TButton>;

    public var buttons(get, null):GameButtons<TButton>;

    var axisCount:Int;
    var _axes = new GameAxesSummator<TAxis>();

    public var axes(get, null):GameAxes<TAxis>;

    var updateBefore:Array<Updatable> = [];

    var oflkbd = new OflKbd();

    public function new(buttonsCount, axisCount) {
        _buttons = new GameButtonsImpl(buttonsCount);
        this.axisCount = axisCount;
    }

    public function createKeyMapping(map:Map<KeyCode, TButton>) {
        var k = new GameKeys(_buttons, map);

        oflkbd.addListener(k);
    }

    public function beforeUpdate(dt) {
        for (u in updateBefore)
            u.update(dt);
    }

    public function afterUpdate() {
        _buttons.frameDone();
    }

    function get_buttons():GameButtons<TButton> {
        return _buttons;
    }

    function get_axes():GameAxes<TAxis> {
        return _axes;
    }

    public function createStick() {
        var stick = new OnScreenStick();
        var adapter = new DummyOflStickAdapter(stick);
        var rend = new DummyOflStickRenderer(stick);
        Lib.current.stage.addChild(rend);
        updateBefore.push(adapter);
        updateBefore.push(rend);
        return stick;
    }
    public function addFakeAxis(keys) {
        var faxes:FakeAxis<TGAxis> = new FakeAxis(keys, axisCount);
        oflkbd.addListener(faxes);
        return faxes;
    }

    public function mapAxisSource<TIn:Axis<TIn>>(stick):AxisMapper<TIn, TAxis> {
        var mapper = AxisMapper.empty(stick, axisCount);
        addAxisSource(mapper);
        return mapper;
    }

    public function addAxisSource(a) {
        _axes.addChild(a);
    }
}

class InputTest extends AbstractEngine {
    // var axes:GameAxes<TGAxis>;
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

        var x = 20;
        var y = 20;
        createButtonVeiw(TGButts.l, x += 40, y);
        createButtonVeiw(TGButts.jump, x += 40, y);
        createButtonVeiw(TGButts.r, x += 40, y);

        var faxes = input.addFakeAxis([Keyboard.J, Keyboard.L, Keyboard.K, Keyboard.I,]);
        y += 40;
        x = 20;
        createAxisView(faxes, TGAxis.h, x, y += 40);
        createAxisView(faxes, TGAxis.v, x, y += 40);

        y -= 80;
        x += 140;

        var stick:AxisDispatcher<Axis2D> = input.createStick();
        var mapper = input.mapAxisSource(cast stick).withMapped(Axis2D.horizontal, TGAxis.h).withMapped(Axis2D.vertical, TGAxis.v);
        createAxisView(mapper, TGAxis.h, x, y += 40);
        createAxisView(mapper, TGAxis.v, x, y += 40);

        y -= 80;
        x += 140;
        createAxisView(input.axes, TGAxis.h, x, y += 40);
        createAxisView(input.axes, TGAxis.v, x, y += 40);

        var a2b = new AxisToButton<Axis2D, TGButts>(Axis2D.aliases.length, stick, cast input.buttons);
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
