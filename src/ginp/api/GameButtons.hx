package ginp.api;

interface GameButtons<T:Axis<T>> {
    public function justPressed(button:T):Bool;

    public function pressed(button:T):Bool;
}
