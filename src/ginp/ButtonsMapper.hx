package ginp;

import ginp.api.GameButtonsDispatcher;
import ginp.api.GameButtonsListener;

class ButtonsMapper<TIn:Axis<TIn>, TOut:Axis<TOut>> implements GameButtonsListener<TIn> implements GameButtonsDispatcher<TOut> {
    var mapping:Map<TIn, TOut>;
    var targets:GameButtonsListeners<TOut> = new GameButtonsListeners();
    var cache:PressCache<TOut> = new PressCache();

    public function new(t, ?m) {
        this.mapping = m != null ? m : new Map();
    }

    public function withMapped(key:TIn, butt:TOut) {
        mapping[key] = butt;
        return this;
    }

    public function onButtonDown(kc:TIn):Void {
        var bt = mapping[kc];
        if (bt == null)
            return;
        targets.onButtonDown(bt);
        cache.onButtonDown(bt);
    }

    public function onButtonUp(kc:TIn):Void {
        var bt = mapping[kc];
        if (bt == null)
            return;
        targets.onButtonUp(bt);
        cache.onButtonUp(bt);
    }

    public function reset() {
        targets.reset(cache);
        cache.reset();
    }

    public function addListener(l:GameButtonsListener<TOut>) {
        targets.push(l);
        cache.pressAll(l);
    }

    public function removeListener(l:GameButtonsListener<TOut>) {
        targets.remove(l);
        cache.releaseAll(l);
    }
}
