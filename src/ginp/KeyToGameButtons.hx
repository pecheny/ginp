package ginp;

import ginp.api.KbdDispatcher;
import ginp.api.KbdListener;
import ginp.GameButtons.GameButtonsImpl;

class KeyToGameButtons<T:Axis<T>> extends GameButtonsImpl<T> {
    var map:Map<Int, T> = new Map();

    /**
        Use listener to send key events from outside or, if you use slec, use bind().
    **/
    @:isVar public var listener(get, null):KbdListener;

    public function addKeymapping(srcMap:Map<Int, T>) {
        for (kv in srcMap.keyValueIterator()) {
            if (map.exists(kv.key)) {
                trace('Key ${kv.key} already mapped, redefinig');
            }
            map[kv.key] = kv.value;
        }
    }

    function get_listener():KbdListener {
        if (listener == null) {
            var k = new GameKeys(this, map);
        }
        return listener;
    }

    #if slec
    override public function bind(e:ec.Entity) {
        super.bind(e);
        e.addComponentByType(KbdListener, listener);
        new ec.CtxWatcher(KbdDispatcher, e);
    }
    #end
}
