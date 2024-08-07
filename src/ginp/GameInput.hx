package ginp;

import ginp.GameButtonsImpl;
import ginp.GameKeys;
import ginp.OnScreenStick;
import ginp.api.GameButtons;
import ginp.api.GameButtonsListener;
import ginp.api.GameInputUpdater;
import ginp.api.KbdListener;
import ginp.axes.AxisMapper;
import ginp.axes.GameAxes;
import update.Updatable;


class GameInput<TAxis:Axis<TAxis>, TButton:Axis<TButton>> implements GameInputUpdater {
    var _buttons:GameButtonsImpl<TButton>;

    public var buttons(get, null):GameButtons<TButton>;
    public var buttonListener(get, null):GameButtonsListener<TButton>;

    var axisCount:Int;
    var _axes = new GameAxesSummator<TAxis>();

    public var axes(get, null):GameAxes<TAxis>;

    var updateBefore:Array<Updatable> = [];


    public function new(axisCount, buttonsCount) {
        _buttons = new GameButtonsImpl(buttonsCount);
        this.axisCount = axisCount;
    }

    public function createKeyMapping(map:Map<KeyCode, TButton>):KbdListener {
        return new GameKeys(_buttons, map);
    }

    public function beforeUpdate(dt) {
        for (u in updateBefore)
            u.update(dt);
    }

    public function afterUpdate() {
        _buttons.afterUpdate();
    }

    public function reset() {
        _buttons.reset();
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
        addAxisSource(faxes);
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
