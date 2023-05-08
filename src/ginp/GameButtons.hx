package ginp;

import macros.AVConstructor;

class GameButtonsImpl<T:Axis<T>> implements GameButtonsListener<T> implements GameButtons<T> {
    var states:AVector<T, Int>;
    var statesPrev:AVector<T, Int>;

    public function new(n:Int) {
        states = AVConstructor.factoryCreate(T, (b:T) -> 0, n);
        statesPrev = AVConstructor.factoryCreate(T, (b:T) -> 0, n);
    }

    public function justPressed(button:T):Bool {
        return states[button] > 0 && statesPrev[button] == 0;
    }

    public function pressed(button:T):Bool {
        return states[button] > 0;
    }

    public function frameDone() {
        for (b in states.axes())
            statesPrev[b] = states[b];
    }

    public function onButtonUp(b:T) {
        states[b] = Std.int(Math.max(0, states[b] - 1));
    }

    public function onButtonDown(b:T) {
        states[b]++;
    }

    public function reset() {
        for (b in states.axes()) {
            states[b] = 0;
            statesPrev[b] = 0;
        }
    }
}

interface GameButtons<T:Axis<T>> {
    public function justPressed(button:T):Bool;

    public function pressed(button:T):Bool;
}

interface GameButtonsListener<T:Axis<T>> {
    public function frameDone():Void;

    public function reset():Void;

    public function onButtonUp(b:T):Void;

    public function onButtonDown(b:T):Void;
}
