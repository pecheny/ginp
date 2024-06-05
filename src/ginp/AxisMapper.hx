package ginp;

import utils.Signal;
import macros.AVConstructor;
import haxe.ds.Vector;
import update.Updatable;
import openfl.Lib;
import openfl.events.MouseEvent;
import openfl.display.Sprite;
import Axis2D;

class AxisMapper<TIn:Axis<TIn>, TOut:Axis<TOut>> implements GameAxes<TOut> {
    var axesMapping:AVector<TOut, TIn>;
    var sources:GameAxes<TIn>;

    function new(s) {
        this.sources = s;
    }

    public function withMapped(from:TIn, to:TOut) {
        if (axesMapping[to] != -1)
            throw "Already has mapping for " + to;
        axesMapping[to] = from;
        return this;
    }

    public function getDirProjection(axis:TOut):Float {
        var trgAxis = axesMapping[axis];
        if (trgAxis != -1)
            return sources.getDirProjection(trgAxis);
        return 0.;
    }

    public static function empty<TIn:Axis<TIn>, TOut:Axis<TOut>>(s:GameAxes<TIn>, numOutAxes:Int):AxisMapper<TIn, TOut> {
        var am = new AxisMapper<TIn, TOut>(s);
        am.axesMapping = AVConstructor.factoryCreate(TOut, _ -> cast -1, numOutAxes);
        return am;
    }

    public static function fromMapping<TIn:Axis<TIn>, TOut:Axis<TOut>>(s:GameAxes<TIn>, mapping:AVector<TOut, TIn>):AxisMapper<TIn, TOut> {
        var am = new AxisMapper<TIn, TOut>(s);
        am.axesMapping = mapping;
        return am;
    }
}
