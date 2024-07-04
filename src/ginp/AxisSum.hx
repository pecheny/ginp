package ginp;

class AxisSum {
    var children:Array<Void->Float> = [];

    public function new() {}

    public function addAxis(a) {
        children.push(a);
    }

    public function getDirProjection():Float {
        var val = 0.;
        for (ch in children) {
            var ga = ch();
            if (Math.abs(ga) > Math.abs(val))
                val = ga;
        }
        return val;
    }
}
