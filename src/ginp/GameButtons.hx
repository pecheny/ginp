package ginp;

import ginp.GameInput.GameInputUpdater;
import ginp.api.GameButtons;
import macros.AVConstructor;

/**
    Provides ```pressed(b)```, ```justPressed(b)``` api according to number of ```onButtonUp(b)```,
    ```onButtonDown(b)``` called in current frame.
    Useful to combine several event sources (i.e. keyboard, gamepad, touchscreen and so on).
    Each source should not call ```onButtonDown(b)``` second time before ```onButtonUp(b)``` for given ```b```.
**/
class GameButtonsImpl<T:Axis<T>> implements GameButtonsListener<T> implements GameButtons<T> implements GameInputUpdater {
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

    function frameDone() {
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

    public function beforeUpdate(dt:Float) {}

    public function afterUpdate() {
        frameDone();
    }

    #if slec
    public function bind(e:ec.Entity) {
        e.addComponentByType(GameInputUpdater, this);
        new ec.CtxWatcher(ginp.api.GameInputUpdaterBinder, e);
    }
    #end
}

interface GameButtonsListener<T:Axis<T>> {
    public function reset():Void;

    public function onButtonUp(b:T):Void;

    public function onButtonDown(b:T):Void;
}
