package openfl;

import ginp.Keyboard;
import ginp.api.KbdDispatcher;
import ginp.api.KbdListener;
import openfl.events.Event;
import openfl.events.KeyboardEvent;

class OflKbd implements KbdDispatcher {
    var listeners:Array<KbdListener> = [];
    inline static var APP_CONTROL_BACK = 0x4000010E;
    public var interceptBack:Bool = true;

    public function new() {
        var dispObj = openfl.Lib.current.stage;
        dispObj.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
        dispObj.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
        dispObj.addEventListener(Event.ACTIVATE, activateListener);
        dispObj.addEventListener(Event.DEACTIVATE, deactivateListener);
    }

    function keyDownListener(e:KeyboardEvent):Void {
        #if back_as_esc
        if (e.keyCode == APP_CONTROL_BACK && interceptBack) {
            e.preventDefault();
            e.stopImmediatePropagation();
            e.stopPropagation();
            for (l in listeners)
                l.keyDownListener(Keyboard.ESCAPE);
            return;
        }
        #end
        for (l in listeners)
            l.keyDownListener(e.keyCode);
    }

    function keyUpListener(e:KeyboardEvent):Void {
        #if back_as_esc
        if (e.keyCode == APP_CONTROL_BACK && interceptBack) {
            e.preventDefault();
            e.stopImmediatePropagation();
            e.stopPropagation();
            for (l in listeners)
                l.keyUpListener(Keyboard.ESCAPE);
            return;
        }
        #end
        for (l in listeners)
            l.keyUpListener(e.keyCode);
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

