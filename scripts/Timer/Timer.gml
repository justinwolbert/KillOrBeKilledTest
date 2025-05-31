function curveLinear() {
    var _channel = animcurve_get_channel(curve_linear, 0);
    var _val = animcurve_channel_evaluate(_channel, sin(current_time/1000)/2+0.5);
    print($"sin: {sin(current_time/1000)}, _val: {_val}");
}
    