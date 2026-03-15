package ginp;

import fu.Signal;
import update.Updatable;
import ginp.api.AxisDispatcher;

class AxisWatcherDispatcher<T:Axis<T>> implements AxisDispatcher<T> implements Updatable {
    var source:Array<Void->Float>;
    var cache:Array<Float>;

    public function new(n, source:Array<Void->Float>) {
        this.source = source;
        cache = [for (i in 0...n) source[i]()];

    }

    public function update(dg:Float) {
        for (i in 0...cache.length) {
            var newVal = source[i]();
            if (newVal!=cache[i]){
                var a:T = cast i;
                axisMoved.dispatch(a, newVal);
                cache[i]=newVal;
            }
        }
    }

    public var axisMoved:Signal<(T, Float) -> Void> = new Signal();
}
