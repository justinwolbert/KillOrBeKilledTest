// Only check if still intact
if (state == 0) {
    // Look for the player nearby (without relying on Collision event)
    var p = instance_nearest(x, y, obj_player);

    if (p != noone && p.dash_state == 2) {
        // Is player close enough to be dashing into this crate?
        var touching = place_meeting(p.x + sign(p.velocity_x) * 2, p.y, id);

        if (touching) {
            // Break the crate
            state        = 1;
            solid        = false;
            sprite_index = Sprite44;
            image_index  = 0;
            image_speed  = sprite_get_number(Sprite44) / room_speed;
            screen_shake(3, 6);
        }
    }
}
