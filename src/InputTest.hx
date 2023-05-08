package;
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

class InputTest extends AbstractEngine {
    var buttons:GameButtons<TGButts>;

    public function new() {
        super();
        var wnd = openfl.Lib.application.window;
        if (wnd.y < 0)
            wnd.y = 20;
        var gameButtons:GameButtons<TGButts> = new GameButtons(TGButts.aliases.length);
        buttons = gameButtons;
        var K = new GameKeys([
            Keyboard.A => TGButts.l,
            Keyboard.D => TGButts.r,
            Keyboard.SPACE => TGButts.jump,
            Keyboard.LEFT => TGButts.l,
            Keyboard.RIGHT => TGButts.r,
            Keyboard.UP => TGButts.jump,
        ], gameButtons);

        var x = 20;
        var y = 20;
        createButtonVeiw(TGButts.l, x+=40, y);
        createButtonVeiw(TGButts.jump, x+=40, y);
        createButtonVeiw(TGButts.r, x+=40, y);
    }

    function createButtonVeiw(b, x, y) {
        var v = new GButtonView(buttons, b);
        addChild(v);
        v.x = x;
        v.y = y;
        addUpdatable(v);
    }
    override function update(t:Float) {
        super.update(t);
        buttons.frameDone();
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

// class AxisView<A:Axis<A>> implements Updatable extends Sprite {
//     var input:GameAxes<A>;
//     var axis:A;

//     public function new(i, a) {
//         super();
//         this.axis = a;
//         this.input = i;
//     }

//     public function update(dt) {
//         graphics.clear();
//         var w = 100;
//         graphics.beginFill(0);
//         graphics.drawRect(0, 0, w, 2);
//         var mw = 4;
//         graphics.beginFill(0xff0000);
//         var pos = input.getDirProjection(axis) / 2 * w + w / 2;
//         graphics.drawRect(pos - mw / 2, 0, mw, 8);
//         graphics.endFill();
//     }
// }
