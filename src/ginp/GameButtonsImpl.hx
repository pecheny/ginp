package ginp;

import ginp.api.GameButtons;
import ginp.api.GameButtonsDispatcher;
import ginp.api.GameButtonsListener;
import ginp.api.GameInputUpdater;
import macros.AVConstructor;

/**
    Provides ```pressed(b)```, ```justPressed(b)``` api according to number of ```onButtonUp(b)```,
    ```onButtonDown(b)``` called in current frame.
    Useful to combine several event sources (i.e. keyboard, gamepad, touchscreen and so on).
    Each source should not call ```onButtonDown(b)``` second time before ```onButtonUp(b)``` for given ```b```.
**/
class GameButtonsImpl<T:Axis<T>> implements GameButtonsListener<T> implements GameButtons<T> implements GameInputUpdater implements GameButtonsDispatcher<T> {
    var states:AVector<T, Int>;
    var statesPrev:AVector<T, Int>;
    var siblings:Array<GameButtonsListener<T>> = [];

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
        for (s in siblings)
            s.onButtonUp(b);
    }

    public function onButtonDown(b:T) {
        states[b]++;
        for (s in siblings)
            s.onButtonDown(b);
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

    public function addListener(l:GameButtonsListener<T>):Void{
        siblings.push(l);
    }

    public function removeListener(l:GameButtonsListener<T>):Void{
        siblings.remove(l);
    }

    #if slec
    public function bind(e:ec.Entity) {
        e.addComponentByType(GameInputUpdater, this);
        new ec.CtxWatcher(ginp.api.GameInputUpdaterBinder, e);
    }
    #end
}
