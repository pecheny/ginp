package ginp;

import macros.AVConstructor;
import ginp.GameButtons.GameButtonsListener;

@:generic
class AxisToButton<T:Axis<T>, TB:Axis<TB>> {
    var target:GameButtonsListener<TB>;
    var source:AxisDispatcher<T>;
    // var mappers:Map<T, Array<AxisToButtonMapper>> = new Map();
    var mappers:AVector<T, Array<AxisToButtonMapper<TB>>>;

    public function new(numAxes, source, target) {
        mappers = AVConstructor.factoryCreate(T, _ -> [], numAxes);
        this.target = target;
        this.source = source;
        onMove(cast 0, 0);
        source.axisMoved.listen( (a,b) -> this.onMove(a,b));
    }

    public function withMapped(to:TB, axis:T, dir:Int) {
        if (dir == -1)
            mappers[axis].push(new AxisToButtonMapper(-1, -0.5, to));
        else if (dir == 1)
            mappers[axis].push(new AxisToButtonMapper(0.5, 1, to));
        else
            throw "Wrong direction";
        return this;
    }

    function onMove(a:T, val:Float) {
        for (mp in mappers[a]) {
            if (mp.justPressed(val))
                target.onButtonDown(mp.targButton);
            if (mp.justReleased(val))
                target.onButtonUp(mp.targButton);
            mp.last = val;
        }
    }
}

class AxisToButtonMapper<TB:Axis<TB>> {
    public var targButton:TB;
    public var min(default, null):Float = 0.5;
    public var max(default, null):Float = 1.;
    public var last:Float = -1.;

    public function new(min, max, tb) {
        this.targButton = tb;
        this.max = max;
        this.min = min;
    }

    public inline function justPressed(val) {
        return inRange(val) && !wasInRange();
    }

    public inline function justReleased(val) {
        return !inRange(val) && wasInRange();
    }

    public inline function wasInRange() {
        return inRange(last);
    }

    public inline function inRange(val) {
        return val >= min && val <= max;
    }
}
