package ginp;

import utils.Updatable;

class AxisToButtons<T:Axis<T>, TB:Axis<TB>> implements GameButtons<TB> implements Updatable {
    var sources:GameAxes<T>;
    var buttons:Map<TB, AxisToButtonMapper<T>> = new Map();

    public function new(s) {
        this.sources = s;
    }

    public function withMappedPositive(b:TB, a:T) {
        if(buttons.exists(b))
            throw "Already has mapping";
        buttons[b] = new AxisToButtonMapper(sources,a);
        return this;
    }

    public function justPressed(button:TB):Bool {
        var b = buttons[button];
        if (b == null)
            return false;
        return b.justPressed();
    }

    public function pressed(button:TB):Bool {
        var b = buttons[button];
        if (b == null)
            return false;
        return b.pressed();
    }

    public function update(dt:Float) {
        for (b in buttons.keys())
            buttons[b].setLastState();
    }
}

class AxisToButtonMapper<T:Axis<T>> {
    var lastState = false;
    var sources:GameAxes<T>;
    var axis:T;
    var min = 0.5;
    var max = 1.;

    public function new(s, a) {
        sources = s;
        axis = a;
    }

    public function justPressed():Bool {
        return !lastState && pressed();
    }

    public function pressed():Bool {
        var val = sources.getDirProjection(axis);
        return val >= min && val <= max;
    }

    public function setLastState() {
        lastState = pressed();
    }
}
