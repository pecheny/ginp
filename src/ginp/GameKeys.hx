package ginp;

import ginp.api.KbdListener;
import ginp.GameButtons.GameButtonsListener;

typedef KeyMapping<GButton:Axis<GButton>> = Map<KeyCode, GButton>;
/**
    Translates keyboard events with keycodes to game buttons events according to given mapping.
**/
class GameKeys<T:Axis<T>> implements KbdListener {
    var mapping:KeyMapping<T>;
    var target:GameButtonsListener<T>;
    var states:Map<KeyCode, Bool> = new Map();

    public function new(t, ?m) {
        this.mapping = m != null ? m : new Map();
        this.target = t;
    }

    public function withMapped(key:KeyCode, butt:T) {
        mapping[key] = butt;
    }

    public function keyDownListener(kc:KeyCode):Void {
        var bt = mapping[kc];
        if (bt == null)
            return;
        if (states[kc])
            return;
        states[kc] = true;
        target.onButtonDown(bt);
    }

    public function keyUpListener(kc:KeyCode):Void {
        var bt = mapping[kc];
        if (bt == null)
            return;
        states[kc] = false;
        target.onButtonUp(bt);
    }

    public function reset() {
        for (key in mapping.keys())
            states[key] = false;
        target.reset();
    }
}
