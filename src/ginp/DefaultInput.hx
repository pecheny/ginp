package ginp;

import ginp.GameInput;
import ginp.Keyboard;

class DefaultInput extends GameInput<Axis2D, OneButton> implements GameAxes<Axis2D> implements GameButtons<OneButton> {
    public var onScreenStick(default, null):OnScreenStick;

    public function new() {
        super(Axis2D.aliases.length, OneButton.aliases.length);
        addAxisSource(addFakeAxis([Keyboard.A, Keyboard.D, Keyboard.S, Keyboard.W]));
        addAxisSource(addFakeAxis([Keyboard.LEFT, Keyboard.RIGHT, Keyboard.DOWN, Keyboard.UP]));
        onScreenStick = createStick();
        addAxisSource(onScreenStick);
        createKeyMapping([Keyboard.SPACE => OneButton.button]);
    }

    public function getDirProjection(axis:Axis2D):Float {
        return axes.getDirProjection(axis);
    }

    public function justPressed(button:OneButton):Bool {
        return buttons.justPressed(button);
    }

    public function pressed(button:OneButton):Bool {
        return buttons.pressed(button);
    }
}

@:build(macros.BuildMacro.buildAxes())
@:enum abstract OneButton(Axis<OneButton>) to Axis<OneButton> to Int {
    var button;
}
