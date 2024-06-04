package ginp.presets;

import ginp.OnScreenStick;

class OneButton2DAxisInput  extends GameInput<Axis2D, OneButton> implements GameAxes<Axis2D> implements GameButtons<OneButton> {
    // public var onScreenStick(default, null):OnScreenStick;

    public function new() {
        super(Axis2D.aliases.length, OneButton.aliases.length);
        addAxisSource(addFakeAxis([Keyboard.A, Keyboard.D, Keyboard.S, Keyboard.W]));
        addAxisSource(addFakeAxis([Keyboard.LEFT, Keyboard.RIGHT, Keyboard.DOWN, Keyboard.UP]));
        createStick();
        createKeyMapping([Keyboard.SPACE => OneButton.button]);
    }

    function createStick() {
        var stick = new OnScreenStick();
        var adapter = new DummyOflStickAdapter(stick);
        addEarlyUpdatable(adapter);
        addAxisSource(stick);
        // onScreenStick = stick;
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