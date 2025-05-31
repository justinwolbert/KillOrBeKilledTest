/// obj_cam_shake : End-Step
if (global._shake_time > 0)
{
    global._shake_time--;

    var a = global._shake_mag;
    global._shake_off_x = irandom_range(-a,  a);
    global._shake_off_y = irandom_range(-a,  a);
}
else
{
    global._shake_off_x = 0;
    global._shake_off_y = 0;
}

