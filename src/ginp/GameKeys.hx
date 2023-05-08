package ginp;

import ginp.GameButtons.GameButtonsListener;
import openfl.events.Event;
import openfl.events.KeyboardEvent;

typedef KeyCode = Int;
typedef KeyMapping<GButton:Axis<GButton>> = Map<KeyCode, GButton>;

class GameKeys<T:Axis<T>> {
    var mapping:KeyMapping<T>;
    var states:Map<KeyCode, Bool> = new Map();
    var target:GameButtonsListener<T>;

    public function new(m, t) {
        this.mapping = m;
        this.target = t;
        var dispObj = openfl.Lib.current.stage;
        dispObj.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
        dispObj.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
        dispObj.addEventListener(Event.ACTIVATE, activateListener);
        dispObj.addEventListener(Event.DEACTIVATE, deactivateListener);
        // Application.current.onKeyDown
    }

    private function keyDownListener(ev:KeyboardEvent):Void {
        var kc = ev.keyCode;
        var bt = mapping[kc];
        if (bt == null)
            return;
        if (states[kc])
            return;
        states[kc] = true;
        target.onButtonDown(bt);
    }

    private function keyUpListener(ev:KeyboardEvent):Void {
        var kc = ev.keyCode;
        var bt = mapping[kc];
        if (bt == null)
            return;
        states[kc] = false;
        target.onButtonUp(bt);
    }

    private function activateListener(ev:Event):Void {
        reset();
        target.reset();
    }

    private function deactivateListener(ev:Event):Void {
        reset();
        target.reset();
    }

    function reset() {
        for (key in mapping.keys())
            states[key] = false;
    }
}
