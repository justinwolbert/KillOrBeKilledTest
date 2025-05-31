/// obj_vertical_moving_platform : Begin-Step
var key_enter = keyboard_check_pressed(vk_enter);

/* ─── state changes ───────────────────────── */
if (move_state == 0 && key_enter) move_state = 1;   // begin slam down
if (move_state == 2 && key_enter) move_state = 3;   // go back up

/* ─── move & physics ──────────────────────── */
var oldy = y;

switch (move_state)
{
    /* ----- 1 » SLAM DOWN  ----------------- */
    case 1:
        // accelerate until max speed
        vsp = min(vsp + accel_down, max_speed_down);

        // if we’re close to the bottom, start braking so we stop exactly on y_end
        if (y + vsp >= y_end - brake_distance) {
            vsp = max( (y_end - y) / 2, 1);   // quick but not overshoot
        }

        y += vsp;

        if (y >= y_end) {
            y      = y_end;
            vsp    = 0;
            move_state = 2;       // idle-bottom
            /* impact effects */
            screen_shake(8, 15);  // amplitude, frames  ← implement in your camera
            //instance_create_layer(x, y, "FXlayer", obj_dust_impact); // optional sprite puff
			
			
			// platform has just hit y_end – spawn dust at its bottom-centre
			var dustY = bbox_bottom;      // bottom of the elevator sprite
			instance_create_layer(x, dustY, "FXlayer", obj_dust_impact);

        }
        break;

    /* ----- 3 » MOVE UP  ------------------- */
    case 3:
        y -= 2;                 // constant speed up
        if (y <= y_start) {
            y = y_start;
            move_state = 0;     // idle-top
        }
        break;
}

dy = y - oldy;    // player uses this in End-Step
