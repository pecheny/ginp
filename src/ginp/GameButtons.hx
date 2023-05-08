package ginp;

import macros.AVConstructor;

class GameButtons<T:Axis<T>> implements GameButtonsListener<T>{
    var statesOdd:AVector<T, Bool>;
    var statesEven:AVector<T, Bool>;
    var states(get, never):AVector<T, Bool>;
    var statesPrev(get, never):AVector<T, Bool>;
    var odd = false;

    public function new(n:Int) {
        statesOdd = AVConstructor.factoryCreate(T, (b:T) -> false, n);
        statesEven = AVConstructor.factoryCreate(T, (b:T) -> false, n);
    }

    public function justPressed(button:T):Bool {
        return states[button] && !statesPrev[button];
    }

    public function pressed(button:T):Bool {
        return states[button];
    }

    public function frameDone() {
        // odd = !odd;
        for (b in states.axes())
            statesPrev[b] = states[b];
    
    }
    public function onButtonUp(b:T) {
        states[b] = false;
    }

    public function onButtonDown(b:T) {
        states[b] = true;
    }

	function get_states():AVector<T, Bool> {
        return if (odd) statesOdd else statesEven;
	}

	function get_statesPrev():AVector<T, Bool> {
        return if (!odd) statesOdd else statesEven;
	}

	public function reset() {}
}

// interface GameButtons<T:Axis<T>> {
//     public function justPressed(button:T):Bool;

//     public function pressed(button:T):Bool;
// }
interface GameButtonsListener<T:Axis<T>> {
    public function frameDone():Void;

    public function reset():Void;

    public function onButtonUp(b:T):Void;

    public function onButtonDown(b:T):Void;
}