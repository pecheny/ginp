package ginp;

import haxe.ds.Vector;
import haxe.ds.ReadOnlyArray;
import ginp.GameKeys.KeyCode;
import ginp.GameKeys.KbdListener;
import ginp.GameButtons.GameButtonsListener;

interface GameAxes<T:Axis<T>> {
    function getDirProjection(axis:T):Float;
}

/**
    Gamepad axes emulation with keyboard. THe first arg is array of keys 
    which are pairs for negative-positive directions of each axis.
**/
class FakeAxis<T:Axis<T>> implements GameAxes<T> implements KbdListener {
    // var mapping:KeyMapping<T>;
    var keys:ReadOnlyArray<KeyCode>;
    var states:Vector<Bool>;

    // var states:Map<KeyCode, Bool> = new Map();

    public function new(keys:ReadOnlyArray<KeyCode>, n) {
        this.keys = keys;
        if (keys.length != n * 2)
            throw "Key list of number of axes x 2 required";
        states = new Vector(keys.length);
    }

    public function keyDownListener(kc:KeyCode):Void {
        var ki = keys.indexOf(kc);
        if (ki < 0)
            return;
        if (states[ki])
            return;
        states[ki] = true;
    }

    public function keyUpListener(kc:KeyCode):Void {
        var ki = keys.indexOf(kc);
        if (ki < 0)
            return;
        states[ki] = false;
    }

    public function reset() {
        for (i in 0...states.length)
            states[i] = false;
    }

    public function getDirProjection(axis:T):Float {
        var keyOffset:Int = axis * 2;
        var val = 0;
        if (states[keyOffset])
            val -= 1;

        if (states[keyOffset + 1])
            val += 1;
        return val;
    }
}
