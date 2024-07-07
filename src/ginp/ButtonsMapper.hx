package ginp;

import ginp.api.GameButtonsListener;


class ButtonsMapper<TIn:Axis<TIn>, TOut:Axis<TOut>> implements GameButtonsListener<TIn>{
    var mapping:Map<TIn,TOut>;
    var target:GameButtonsListener<TOut>;

    public function new(t, ?m) {
        this.mapping = m != null ? m : new Map();
        this.target = t;
    }

    public function withMapped(key:TIn, butt:TOut) {
        mapping[key] = butt;
        return this;
    }

    public function onButtonDown(kc:TIn):Void {
        var bt = mapping[kc];
        if (bt == null)
            return;
        target.onButtonDown(bt);
    }

    public function onButtonUp(kc:TIn):Void {
        var bt = mapping[kc];
        if (bt == null)
            return;
        target.onButtonUp(bt);
    }

    public function reset() {
        target.reset();
    }
}