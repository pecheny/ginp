package ginp;

import ginp.GameButtons.GameButtonsListener;
import openfl.events.Event;
import openfl.events.KeyboardEvent;

typedef KeyCode = Int;
typedef KeyMapping<GButton:Axis<GButton>> = Map<KeyCode, GButton>;

class OflKbd {
    var listeners:Array<KbdListener> = [];

    public function new() {
        var dispObj = openfl.Lib.current.stage;
        dispObj.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
        dispObj.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
        dispObj.addEventListener(Event.ACTIVATE, activateListener);
        dispObj.addEventListener(Event.DEACTIVATE, deactivateListener);
        // Application.current.onKeyDown
    }

    function keyDownListener(ev:KeyboardEvent):Void {
        for (l in listeners)
            l.keyDownListener(ev.keyCode);
    }

    function keyUpListener(ev:KeyboardEvent):Void {
        for (l in listeners)
            l.keyUpListener(ev.keyCode);
    }

    function activateListener(ev:Event):Void {
        for (l in listeners)
            l.reset();
    }

    function deactivateListener(ev:Event):Void {
        for (l in listeners)
            l.reset();
    }

    public function addListener(l) {
        listeners.push(l);
    }
}

interface KbdListener {
    public function keyDownListener(kc:KeyCode):Void;

    public function keyUpListener(kc:KeyCode):Void;

    public function reset():Void;
}

class GameKeys<T:Axis<T>> implements KbdListener {
    var mapping:KeyMapping<T>;
    var target:GameButtonsListener<T>;
    var states:Map<KeyCode, Bool> = new Map();

    public function new(m, t) {
        this.mapping = m;
        this.target = t;
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
