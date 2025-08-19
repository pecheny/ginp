package ginp;

import fu.Signal;
import ginp.api.GameButtonsListener;

class ButtonSignals<T:Axis<T>> implements GameButtonsListener<T> {
    public var onPress(default, null):Signal<T->Void> = new Signal();
    public var onRelease(default, null):Signal<T->Void> = new Signal();

    public function new() {}

    public function reset() {}

    public function onButtonUp(b:T):Void{
        onRelease.dispatch(b);
    }

    public function onButtonDown(b:T):Void {
        onPress.dispatch(b);
    }
}
