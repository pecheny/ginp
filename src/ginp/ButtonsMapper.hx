package ginp;

import ginp.api.GameButtonsListener;


class ButtonsMapper<TIn:Axis<TIn>, TOut:Axis<TOut>> implements GameButtonsListener<TIn>{
    var mapping:Map<TIn,TOut>;
    var target:GameButtonsListener<TOut>;
    var states:Map<TIn, Bool> = new Map();

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
        if (states[kc])
            return;
        states[kc] = true;
        target.onButtonDown(bt);
    }

    public function onButtonUp(kc:TIn):Void {
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