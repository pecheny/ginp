package ginp.presets;

@:build(macros.BuildMacro.buildAxes())
@:enum abstract OneButton(Axis<OneButton>) to Axis<OneButton> to Int {
    var button;
}