package ginp;

import ginp.axes.GameAxes;
import ginp.axes.AxisMapper;
import ginp.GameButtons;
import ginp.GameKeys;
import ginp.OnScreenStick;
import ginp.api.KbdListener.KeyCode;
import openfl.OflKbd;
import update.Updatable;

interface GameInputUpdater {
    public function beforeUpdate(dt:Float):Void;
    public function afterUpdate():Void;
}

class GameInput<TAxis:Axis<TAxis>, TButton:Axis<TButton>> implements GameInputUpdater {
    var _buttons:GameButtonsImpl<TButton>;

    public var buttons(get, null):GameButtons<TButton>;
    public var buttonListener(get, null):GameButtonsListener<TButton>;

    var axisCount:Int;
    var _axes = new GameAxesSummator<TAxis>();

    public var axes(get, null):GameAxes<TAxis>;

    var updateBefore:Array<Updatable> = [];

    var oflkbd = new OflKbd();

    public function new(axisCount, buttonsCount) {
        _buttons = new GameButtonsImpl(buttonsCount);
        this.axisCount = axisCount;
    }

    public function createKeyMapping(map:Map<KeyCode, TButton>) {
        var k = new GameKeys(_buttons, map);
        oflkbd.addListener(k);
    }

    public function beforeUpdate(dt) {
        for (u in updateBefore)
            u.update(dt);
    }

    public function afterUpdate() {
        _buttons.frameDone();
    }

    function get_buttons():GameButtons<TButton> {
        return _buttons;
    }

    function get_buttonListener() {
        return _buttons;
    }

    function get_axes():GameAxes<TAxis> {
        return _axes;
    }

    public function addEarlyUpdatable(u) {
        updateBefore.push(u);
    }

    public function addFakeAxis(keys):FakeAxis<TAxis> {
        var faxes = new FakeAxis(keys, axisCount);
        oflkbd.addListener(faxes);
        return faxes;
    }

    public function mapAxisSource<TIn:Axis<TIn>>(stick):AxisMapper<TIn, TAxis> {
        var mapper = AxisMapper.empty(stick, axisCount);
        addAxisSource(mapper);
        return mapper;
    }

    public function addAxisSource(a) {
        _axes.addChild(a);
    }
}
