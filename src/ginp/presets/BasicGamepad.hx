package ginp.presets;

import ginp.api.KbdListener;
import ginp.GameButtonsImpl;

@:build(macros.BuildMacro.buildAxes())
enum abstract BasicGamepadButtons(Axis<BasicGamepadButtons>) to Axis<BasicGamepadButtons> to Int {
    var left;
    var right;
    var up;
    var down;
    var a;
    var b;
    var x;
    var y;
    var start;
    var tleft;
    var tright;
}

class BasicGamepadInput extends GameButtonsImpl<BasicGamepadButtons> {
    var kbd = new openfl.OflKbd();
    public function new() {
        super(BasicGamepadButtons.aliases.length);
    }

    public function createKeyMapping(map:Map<KeyCode, BasicGamepadButtons>) {
        var gk = new ginp.GameKeys(map);
        gk.addListener(this);
        kbd.addListener(gk);
        // return gk;
    }
}
