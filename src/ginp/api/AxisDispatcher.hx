package ginp.api;

import utils.Signal;

interface AxisDispatcher<T:Axis<T>> {
    var axisMoved:Signal<(T, Float) -> Void>;
}
