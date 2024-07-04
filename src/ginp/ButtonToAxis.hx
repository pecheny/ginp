package ginp;

import ginp.api.GameAxis;
import ginp.api.GameButtons;
class ButtonToAxis<TB:Axis<TB>, T:Axis<T>> {
    var buttons:GameButtons<TB>;
    var pb:TB;
    var nb:TB;

    public function new(buttons:GameButtons<TB>, pb:TB, nb:TB) {
        this.buttons = buttons;
        this.pb = pb;
        this.nb = nb;
    }

    public function getDirProjection():Float {
        var r = 0;
        if (buttons.pressed(pb))
            r++;
        if (buttons.pressed(nb))
            r--;
        return r;
    }
}
