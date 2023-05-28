package ginp.api;

typedef KeyCode = Int;

interface KbdListener {
    public function keyDownListener(kc:KeyCode):Void;

    public function keyUpListener(kc:KeyCode):Void;

    public function reset():Void;
}
