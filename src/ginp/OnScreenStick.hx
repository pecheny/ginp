package ginp;

import utils.Signal;
import macros.AVConstructor;
import haxe.ds.Vector;
import update.Updatable;
import openfl.Lib;
import openfl.events.MouseEvent;
import openfl.display.Sprite;
import Axis2D;

class AxisMapper<TIn:Axis<TIn>, TOut:Axis<TOut>> implements GameAxes<TOut> {
    var axesMapping:AVector<TOut, TIn>;
    var sources:GameAxes<TIn>;

    function new(s) {
        this.sources = s;
    }

    public function withMapped(from:TIn, to:TOut) {
        if (axesMapping[to] != -1)
            throw "Already has mapping for " + to;
        axesMapping[to] = from;
        return this;
    }

    public function getDirProjection(axis:TOut):Float {
        var trgAxis = axesMapping[axis];
        if (trgAxis != -1)
            return sources.getDirProjection(trgAxis);
        return 0.;
    }

    public static function empty<TIn:Axis<TIn>, TOut:Axis<TOut>>(s:GameAxes<TIn>, numOutAxes:Int):AxisMapper<TIn, TOut> {
        var am = new AxisMapper<TIn, TOut>(s);
        am.axesMapping = AVConstructor.factoryCreate(TOut, _ -> cast -1, numOutAxes);
        return am;
    }

    public static function fromMapping<TIn:Axis<TIn>, TOut:Axis<TOut>>(s:GameAxes<TIn>, mapping:AVector<TOut, TIn>):AxisMapper<TIn, TOut> {
        var am = new AxisMapper<TIn, TOut>(s);
        am.axesMapping = mapping;
        return am;
    }
}

class OnScreenStick implements GameAxes<Axis2D> implements AxisDispatcher<Axis2D> {
    public var origin:Vector2D<Float> = new Vector2D();
    public var pos:Vector2D<Float> = new Vector2D();

    public var r:Float = 60;
    public var axisMoved:Signal<(Axis2D, Float) -> Void> = new Signal();

    public function new() {}

    public function setPos(x, y) {
        pos.init(x, y);
        pos.remove(origin);
        if (pos.lenSq() > r * r)
            pos.normalize(r);
        axisMoved.dispatch(horizontal, pos[horizontal] / r);
        axisMoved.dispatch(vertical, pos[vertical] / r);
    }

    public function setOrigin(x, y) {
        origin.init(x, y);
    }

    public function getDirProjection(axis:Axis2D):Float {
        return pos[axis] / r;
    }

    public var active(default, null) = false;

    public function onDown(mouseX, mouseY) {
        setOrigin(mouseX, mouseY);
        setPos(mouseX, mouseY);
        active = true;
    }

    public function onUp() {
        setOrigin(0, 0);
        setPos(0, 0);
        active = false;
    }
}

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

@:forward(get)
abstract Vector2D<TUnit:Float>(Vector<TUnit>) {
    public var x(get, set):TUnit;
    public var y(get, set):TUnit;

    public inline function new(x = 0., y = 0.) {
        this = new Vector(2);
        init(cast x, cast y);
    }

    public inline function init(x, y) {
        this.set(0, x);
        this.set(1, y);
        return toThis();
    }

    public inline function get_x():TUnit {
        return this[0];
    }

    public inline function get_y():TUnit {
        return this[1];
    }

    public inline function set_x(value:TUnit):TUnit {
        return this.set(0, value);
    }

    public inline function set_y(value:TUnit):TUnit {
        return this.set(1, value);
    }

    @:arrayAccess public inline function set(a:Axis2D, val) {
        return this.set(a, val);
    }

    @:arrayAccess public inline function get(a:Axis2D) {
        return this.get(a);
    }

    public inline function copyFrom(f:Vector2DRO<TUnit>) {
        this[0] = f.x;
        this[1] = f.y;
        return toThis();
    }

    inline function toThis():Vector2D<TUnit> {
        return cast this;
    }

    @:to public function to_Vector2DRO():Vector2DRO<TUnit> {
        return cast this;
    }

    public inline function toString() {
        return '[$x, $y]';
    }

    public inline function add(other:Vector2DRO<TUnit>):Vector2D<TUnit> {
        x += other.x;
        y += other.y;
        return cast this;
    }

    public inline function remove(other:Vector2DRO<TUnit>):Vector2D<TUnit> {
        x -= other.x;
        y -= other.y;
        return cast this;
    }

    public inline function dot(other:Vector2DRO<TUnit>) {
        return x * other.x + y * other.y;
    }

    public inline function mul(m:TUnit):Vector2D<TUnit> {
        x *= m;
        y *= m;
        return toThis();
    }

    public inline function normalize(length:Float = 1):Vector2D<TUnit> {
        if (x != 0. || y != 0.) {
            var norm:TUnit = cast length / Math.sqrt(x * x + y * y);
            x *= norm;
            y *= norm;
        }
        return cast this;
    }

    public inline function flip() {
        x *= -1;
        y *= -1;
        return this;
    }

    public inline function reflect(normal:Vector2DRO<TUnit>) {
        var diff:Vector2D<TUnit> = cast normal.clone().mul(dot(normal) * 2);
        remove(diff);
        return toThis();
    }

    public inline function distance(other:Vector2DRO<TUnit>) {
        var dx = other.x - x;
        var dy = other.y - y;
        return Math.sqrt(dx * dx + dy * dy);
    }

    public inline function lenSq() {
        return x * x + y * y;
    }
}

abstract Vector2DRO<TUnit:Float>(haxe.ds.Vector<TUnit>) {
    public static var ZERO = new Vector2DRO(0, 0);

    public inline function new(x, y) {
        this = new Vector(2);
        this.set(0, x);
        this.set(1, y);
    }

    public var x(get, never):TUnit;
    public var y(get, never):TUnit;

    public inline function get_x():TUnit {
        return this[0];
    }

    public inline function get_y():TUnit {
        return this[1];
    }

    public inline function get(a:Axis2D)
        return this.get(a);

    public inline function toString() {
        return '[$x, $y]';
    }

    public inline function distance(other:Vector2DRO<TUnit>) {
        var dx = other.x - x;
        var dy = other.y - y;
        return Math.sqrt(dx * dx + dy * dy);
    }

    public inline function dot(other:Vector2DRO<TUnit>) {
        return x * other.x + y * other.y;
    }

    public inline function length() {
        return Math.sqrt(x * x + y * y);
    }

    public inline function clone() {
        return new Vector2D<TUnit>(x, y);
    }
}
