package ginp.api;

interface GameButtonsDispatcher<T:Axis<T>> //  #if slec extends ec.CtxWatcher.CtxBinder #end
{
    function addListener(l:GameButtonsListener<T>):Void;
    function removeListener(l:GameButtonsListener<T>):Void;
}

abstract PressCache<T:Axis<T>>(Array<T>) {
    public inline function new() {
        this = [];
    }

    public inline function onButtonUp(b:T) {
        this.remove(b);
    }

    public inline function onButtonDown(b:T) {
        #if debug
        if (this.indexOf(b) > -1)
            throw "Already pressed " + b;
        #end
        this.push(b);
    }

    public function reset() {
        this.resize(0);
    }

    public inline function releaseAll(target:GameButtonsListener<T>) {
        for (a in this)
            target.onButtonUp(a);
    }

    public inline function pressAll(target:GameButtonsListener<T>) {
        for (a in this)
            target.onButtonDown(a);
    }
}

@:forward(push, remove)
abstract GameButtonsListeners<T:Axis<T>>(Array<GameButtonsListener<T>>) {
    public inline function new() {
        this = [];
    }

    public inline function asArray():Array<GameButtonsListener<T>> {
        return this;
    }

    public inline function reset(c:PressCache<T>) {
        for (l in this)
            c.releaseAll(l);
    }

    public inline function onButtonUp(b:T) {
        for (l in this)
            l.onButtonUp(b);
    }

    public inline function onButtonDown(b:T) {
        for (l in this)
            l.onButtonDown(b);
    }
}
