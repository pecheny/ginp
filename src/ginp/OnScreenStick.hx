package ginp;

import Axis2D;
import ginp.axes.GameAxes;
import hxmath.math.MathUtil;
import hxmath.math.Vector2;
import utils.Signal;
import ginp.api.AxisDispatcher;

class OnScreenStick implements GameAxes<Axis2D> implements AxisDispatcher<Axis2D> {
    public var origin = new Vector2(0, 0);
    public var pos = new Vector2(0, 0);
    public var onActiveToggle:Signal<Bool->Void> = new Signal();

    public var r:Float = 60;
    public var axisMoved:Signal<(Axis2D, Float) -> Void> = new Signal();

    public function new(r) {
        this.r = r;
    }

    public function setPos(x, y) {
        if (!active)
            return;
        pos.set(x, y);
        pos.subtractWith(origin);
        if (pos.lengthSq > r * r)
            pos.normalizeTo(r);
        axisMoved.dispatch(horizontal, pos[horizontal] / r);
        axisMoved.dispatch(vertical, pos[vertical] / r);
    }

    public function setOrigin(x, y) {
        origin.set(x, y);
    }

    public function getDirProjection(axis:Axis2D):Float {
        return pos[axis] / r;
    }

    public var active(default, null) = false;

    public function onDown(mouseX, mouseY) {
        setOrigin(mouseX, mouseY);
        setPos(mouseX, mouseY);
        active = true;
        onActiveToggle.dispatch(active);
    }

    public function onUp() {
        setOrigin(0, 0);
        setPos(0, 0);
        active = false;
        onActiveToggle.dispatch(active);
    }
}

class CircularStick extends OnScreenStick {

    override function setPos(x:Float, y:Float) {
        if (!active)
            return;
        pos.set(x, y);
        pos.subtractWith(origin);
        if (pos.lengthSq > r * r)
            pos.normalizeTo(r);
        axisMoved.dispatch(horizontal, pos[horizontal] / r);
        axisMoved.dispatch(vertical, pos[vertical] / r);
    }
    
}

class SquareStick extends OnScreenStick {

    override function setPos(x:Float, y:Float) {
        if (!active)
            return;
        pos.set(x, y);
        pos.subtractWith(origin);
        for (a in Axis2D)
            pos[a] = MathUtil.clamp(pos[a], -r, r);
        axisMoved.dispatch(horizontal, pos[horizontal] / r);
        axisMoved.dispatch(vertical, pos[vertical] / r);
    }
    
}