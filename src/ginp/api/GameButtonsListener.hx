package ginp.api;

interface GameButtonsListener<T:Axis<T>> {
    public function reset():Void;

    public function onButtonUp(b:T):Void;

    public function onButtonDown(b:T):Void;
}
