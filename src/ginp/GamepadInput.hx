package input;
// import input.Input.GameButtons;
import lime.ui.Gamepad;
import Axis2D;
class GamepadInput {
    var horizontalAxis:GamepadAxis;
    var verticalAxis:GamepadAxis;
    var values = new AxisCollection2D<Float>(0);
    var mapping:Map<GamepadButton, LGameButtons>;

    public function new(horizontal:GamepadAxis, vertical:GamepadAxis, mapping) {
        this.mapping = reverseMap(mapping);
        horizontalAxis = horizontal;
        verticalAxis = vertical;
        Gamepad.onConnect.add(init);
        init(null);
    }

    function init(_) {
        var gp:Gamepad = null;
        for (g in Gamepad.devices) {
            trace("g " + g);
            gp = g; break;
        }
        if (gp == null) {
            trace("Null gamepad");
            return;
        }

        gp.onAxisMove.add(axisHandler);
        gp.onButtonDown.add(onButtonDown);
        gp.onButtonUp.add(onButtonUp);
    }

    inline function process(val:Float) {
        return if (val * val < 0.1)
            0;
        else val;
    }

    var buttons = new Map<GameButtons, Bool>();

    public function pressed(button:GameButtons):Bool {
        return buttons.exists(button) && buttons.get(button);
    }

    function onButtonUp(b:GamepadButton) {
        buttons[mapping[b]] = false;
    }

    function onButtonDown(b:GamepadButton) {
        buttons[mapping[b]] = true;
    }

    function axisHandler(axis, value) {
        if (axis == horizontalAxis) {
            values[horizontal] = process(value);
        } else if (axis == verticalAxis) {
            values[vertical] = process(value);
        }
    }

    public function getDirProjection(axis:Axis2D):Float {
        return values[axis];
    }

    function reverseMap<K, T:Int>(inp:Map<K, T>):Map<T, K> {
        var o = new Map<T,K>();
        for (kv in inp.keyValueIterator()) {
            o[kv.value] = kv.key;
        }
        return o;
    }
}

// typedef GamepadAxis = lime.ui.GamepadAxis;
@:build(macros.BuildMacro.buildAxes())
@:enum abstract GamepadAxis (Axis<GamepadAxis>) to Axis<GamepadAxis> to Int {
	var LEFT_X = 0;
	var LEFT_Y = 1;
	var RIGHT_X = 2;
	var RIGHT_Y = 3;
	var TRIGGER_LEFT = 4;
	var TRIGGER_RIGHT = 5;
}
typedef LGamepadButton = lime.ui.GamepadButton;
