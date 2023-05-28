package openfl;

import ginp.api.KbdListener;
import openfl.events.Event;
import openfl.events.KeyboardEvent;

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
