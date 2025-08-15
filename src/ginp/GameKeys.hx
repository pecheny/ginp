package ginp;

import ginp.api.GameButtonsDispatcher;
import ginp.api.GameButtonsListener;
import ginp.api.KbdListener;

typedef KeyMapping<GButton:Axis<GButton>> = Map<KeyCode, GButton>;

/**
    Translates keyboard events with keycodes to game buttons events according to given mapping.
**/
class GameKeys<T:Axis<T>> implements KbdListener implements GameButtonsDispatcher<T> {
    var mapping:KeyMapping<T>;
    var targets:GameButtonsListeners<T> = new GameButtonsListeners();
    var cache:PressCache<T> = new PressCache();
    var states:Map<KeyCode, Bool> = new Map();

    public function new(?m) {
        this.mapping = m != null ? m : new Map();
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
        targets.onButtonDown(bt);
        cache.onButtonDown(bt);
    }

    public function keyUpListener(kc:KeyCode):Void {
        var bt = mapping[kc];
        if (bt == null)
            return;
        states[kc] = false;
        targets.onButtonUp(bt);
        cache.onButtonUp(bt);
    }

    public function reset() {
        for (key in mapping.keys())
            states[key] = false;
        targets.reset(cache);
        cache.reset();
    }

    public function addListener(l:GameButtonsListener<T>) {
        targets.push(l);
        cache.pressAll(l);
    }

    public function removeListener(l:GameButtonsListener<T>) {
        targets.remove(l);
        cache.releaseAll(l);
    }

}
