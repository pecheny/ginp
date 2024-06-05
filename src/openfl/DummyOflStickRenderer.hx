package openfl;

import ginp.OnScreenStick;
import openfl.display.Sprite;
import update.Updatable;

class DummyOflStickRenderer extends Sprite implements Updatable {
    var stick:OnScreenStick;

    public function new(s) {
        super();
        this.stick = s;
    }

    public function update(dt) {
        graphics.clear();
        if (!stick.active)
            return;
        graphics.beginFill(0xffffff, 0.3);
        graphics.drawCircle(stick.origin.x, stick.origin.y, stick.r);
        graphics.endFill();
        graphics.beginFill(0x202020, 0.6);
        graphics.drawCircle(stick.origin.x + stick.pos.x, stick.origin.y + stick.pos.y, 5);
        graphics.endFill();
    }
}
