package openfl;

import ginp.api.KbdDispatcher;
import ginp.api.KbdListener;
import openfl.events.Event;
import openfl.events.KeyboardEvent;

class OflKbd implements KbdDispatcher {
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

    public function addListener(l):Void {
        listeners.push(l);
    }

    public function removeListener(l):Void {
        listeners.remove(l);
    }

    #if slec
    public function bind(e:ec.Entity) {
        var l = e.getComponent(KbdListener);
        if (l != null)
            addListener(l);
    }

    public function unbind(e:ec.Entity) {
        var l = e.getComponent(KbdListener);
        if (l != null)
            removeListener(l);
    }
    #end
}
