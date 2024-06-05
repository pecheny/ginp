package openfl;

import ginp.OnScreenStick;
import openfl.Lib;
import openfl.events.MouseEvent;
import update.Updatable;

class DummyOflStickAdapter<T:Axis<T>> implements Updatable {
    var stick:OnScreenStick;

    public function new(s) {
        this.stick = s;
        Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
        Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
    }

    function onDown(e:MouseEvent) {
        stick.onDown(Lib.current.stage.mouseX, Lib.current.stage.mouseY);
    }

    function onUp(e:MouseEvent) {
        stick.onUp();
    }

    public function update(dt) {
        if (!stick.active)
            return;
        stick.setPos(Lib.current.stage.mouseX, Lib.current.stage.mouseY);
    }
}
