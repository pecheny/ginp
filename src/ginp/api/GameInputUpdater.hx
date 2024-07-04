package ginp.api;

interface GameInputUpdater {
    public function beforeUpdate(dt:Float):Void;
    public function afterUpdate():Void;
}