package ginp.presets;

class OneButtonInput  extends GameInput<NullAxis, OneButton> implements GameAxes<NullAxis> implements GameButtons<OneButton> {
    public var onScreenStick(default, null):OnScreenStick;

    public function new() {
        super(NullAxis.aliases.length, OneButton.aliases.length);
        createKeyMapping([Keyboard.SPACE => OneButton.button]);
    }

    public function getDirProjection(axis:NullAxis):Float {
        throw "N/A";
    }

    public function justPressed(button:OneButton):Bool {
        return buttons.justPressed(button);
    }

    public function pressed(button:OneButton):Bool {
        return buttons.pressed(button);
    }
}