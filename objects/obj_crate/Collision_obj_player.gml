show_debug_message("Collision");


//// obj_crate : Collision with obj_player
//if (state == 0)                 // only care while intact
//{
//    if (other.dash_state == 2)  // player is in “active dash” window
//    {
//        /// begin break animation
//        state        = 1;
//        solid        = false;           // so nothing gets stuck
//        sprite_index = spr_crate;
//        image_index  = 0;
//        image_speed  = 1 / room_speed;  // - plays in ~1 sec; tweak
//        screen_shake(3, 6);
//    }
//}
//show_debug_message(string(dash_state));