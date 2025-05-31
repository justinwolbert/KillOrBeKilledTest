//////////////////////////////////////////////
//// STEP EVENT - With One-Sided Fix + Momentum Jump
//////////////////////////////////////////////

//#region Movement
///* How movement features
//Apart from up down left right, there are 
//- Anti Gravity Apex [Done]
//- Early Fall [Done]
//- Jump Buffering [Done]
//- Sticky Feet [Done]
//- Speedy apex [Done]
//- Coyote jump [Done] + velocity_x boost ;^] //3rd Hardest to implement
//- Clamped fall speed [Done]
//- Bumped corner teleporting [Done]
//- Bumped head on corner [Done] 
//- Double Jump [Done]
//- Crouch on edge [Done] //but needs to add camera peeking
//- Momentum Jump [Done]
//- Ground Pound [Done] //but needs to gameplay test keys // 4rd Hardest
//- Wall climb [Done] // 2nd Hardest
//- One sided platforms [Partly Done] // But see BUG: DOWN then CROUCH doesn't jump down.
//- Dash [] // Gives invulnerability frames aka i-frames // 1st Hardest
//TODO: 
//- fall damage // Need to implement Health first
//*/

//// 1) ESC Key to Quit
//if (keyboard_check_pressed(vk_escape)) {
//    game_end();
//}

//// 2) INPUTS
//var L     = input_check("left");
//var R     = input_check("right");

//// Merge Up Arrow + Space (or "accept") into single jump booleans
//var jumpPressed  = (input_check_pressed("up") || input_check_pressed("accept"));
//var jumpHold     = (input_check("up")         || input_check("accept"));
//var jumpRelease  = (input_check_released("up")|| input_check_released("accept"));

//// Crouch & Down
//// CHANGED: let's check "down" as *held* instead of just pressed, 
//// to fix the ordering bug (Down then Crouch) for one-sided platforms
//var CROUCH    = input_check("crouch");
//var DOWN      = input_check("down");  // used to be input_check_pressed("down")

//// Dash
//var DASH      = input_check_pressed("dash");

//var ATTACK = input_check_pressed("shoot");   

//var skip_gravity = false;



////STUN LOGIC
///* freeze input during spike stun ---------------------------*/
//if (stun_timer > 0)
//{
//    stun_timer--;

//    // ignore all controls this frame
//    L = 0;
//    R = 0;
//    jumpPressed  = jumpHold = jumpRelease = false;
//    DASH = false;

//    // **no teleport when timer ends**  ← removed
//}


//// 3) DASH STATE MACHINE (Celeste-style)
//if (DASH && dash_state == 0) {
//    dash_state = 1; // enter dash anticipation
//    dash_timer = 0;
//}

//// Dash Anticipation
//if (dash_state == 1) {
//    // Freeze player
//    velocity_x = 0;
//    velocity_y = 0;
//    dash_timer++;
//    if (dash_timer >= DASH_ANTICIPATION) {
//        // move on to dash
//        dash_state = 2;
//        dash_timer = 0;
//        velocity_x = facing_direction * (max_velocity_x * 2);
//    }
//}
//// Dash Active
//else if (dash_state == 2) {
//    // Force horizontal dash each frame
//    velocity_y = 0;
//    velocity_x = facing_direction * (max_velocity_x * 2);

//    dash_timer++;
//    if (dash_timer >= DASH_DURATION) {
//        dash_state = 0;
//        dash_timer = 0;
//    }
//}

//// 4) HORIZONTAL FORCE (Only if NOT dashing)
//if (dash_state == 0) {
//    // Normal horizontal movement
//    if (L != 0 || R != 0) {
//        // If both pressed => decelerate
//        if (L != 0 && R != 0) {
//            if (velocity_x > 1)      velocity_x -= decceleration_x;
//            else if (velocity_x < -1)velocity_x += decceleration_x;
//            else                     velocity_x  = 0;
//        }
//        else {
//            // Single direction => accelerate
//            velocity_x += (R - L) * acceleration_x;
//            velocity_x  = clamp(velocity_x, -max_velocity_x, max_velocity_x);
//        }
//    }
//    else {
//        // No input => decelerate
//        if (abs(velocity_x) > 1) {
//            if (velocity_x > 0) velocity_x -= decceleration_x;
//            else               velocity_x += decceleration_x;
//        } else {
//            velocity_x = 0;
//        }
//    }
//}








///* ============================================================
//   ATTACK  (simple 6-frame sword swipe)
//   ============================================================ */
//if (attack_cooldown > 0) attack_cooldown--;

//if (attack_timer > 0)            // we are mid-swing
//{
//    attack_timer--;
//    if (attack_timer == 3)       // on the 2nd frame create hitbox
//    {
//        var hit_x = x + facing_direction * 10;   // in front of player
//        var hit_y = y - 4;                       // chest height
//        instance_create_layer(hit_x, hit_y, "Instances", obj_attack);
//    }
//}
//else
//{
//    if (ATTACK && attack_cooldown == 0 && grounded)  // start new swing
//    {
//        attack_timer    = 6;        // total animation frames
//        attack_cooldown = 15;       // delay before next swing
//    }
//}












//// 5) VERTICAL FORCE + UNIFIED JUMP
//// keep track of jump input frames
//if (jumpPressed) {
//    UP_frames_ago = 0;
//} else {
//    UP_frames_ago++;
//}

//// Decide if can jump
//var can_jump = false;
//if (grounded) {
//    can_jump = true;
//}
//// coyote jump
//if (grounded_frames_ago < 8 && !grounded) {
//    can_jump = true;
//}
//// double jump
//if (unlocked_double_jump && jump_count < max_jumps) {
//    if (grounded_frames_ago > 8) {
//        can_jump = true;
//    }
//}
//// jump buffering
//if (UP_frames_ago < 7 && frames_going_down > 2) {
//    jumpPressed = true;
//}

//var doJump = false;
//if (jumpPressed && can_jump) {
//    doJump = true;
//}

//// Actually apply jump
//if (doJump) {
//    //-------------------------------------------------
//    // MOMENTUM JUMP: (NEW CODE)
//    // If running fast, jump higher/farther.
//    // e.g., +50% jump at max speed.
//    //-------------------------------------------------
//    var momentum_factor = abs(velocity_x) / max_velocity_x; // 0..1
//    var jump_force_constant = 1.0 + 0.25 * momentum_factor;
//    // If you want a bigger boost, change 0.5 to 0.75 or 1.0, etc.

//    velocity_y += jump_force * jump_force_constant;
//    jump_count++;

//    // coyote boost if midair on 1st jump
//    if (!grounded && jump_count == 1) {
//        max_velocity_x   = coyote_boost;
//        coyote_boost_timer = 90;
//    }
//}

//// coyote boost timer
//if (coyote_boost_timer > 0) {
//    coyote_boost_timer--;
//    max_velocity_x = lerp(_max_velocity_x, coyote_boost, coyote_boost_timer / 90);
//}

//// Early Fall => jump cut
//if (jumpRelease && !grounded && velocity_y < 0) {
//    velocity_y = 0;
//}

//// apex logic
//at_apex    = false;
//fall_speed = normal_fall_speed;
//if (abs(velocity_y) <= apex_threshold && !grounded) {
//    at_apex    = true;
//    fall_speed = apex_fall_speed;
//}
//// gravity
//if (!skip_gravity) {
//	velocity_y += fall_speed;
//	velocity_y  = clamp(velocity_y, fall_speed_min, fall_speed_max);
//}



///* ──────────────────────────────────────────
//  /// Vertical moving platform
//   ────────────────────────────────────────── */
//var elev = instance_place(x, bbox_bottom + 1, obj_vertical_moving_platform);

//if (elev != noone && velocity_y >= 0 && !jumpPressed)

//{
//    // snap flush
//    var elevTop      = elev.bbox_top;
//    var playerHeight = bbox_bottom - bbox_top;
//    y = elevTop - playerHeight;

//	// ride smoothly
//	y += elev.dy;

//	// only push us DOWN with the platform.
//	// while it’s going UP keep vspeed 0 so
//	// the ground-check doesn’t fight gravity.
//	if (elev.dy > 0) {
//	    velocity_y = elev.dy;   // moving down
//	} else {
//	    velocity_y = 0;         // moving up → stay stationary
//	}

//    skip_gravity = true;      // ensures gravity skipped next loop
//}



//// 6) POSITION PREVIEW & SPECIAL MOVES
//position_x = x + velocity_x;
//position_y = y + velocity_y;

//// Ground Pound
//if (unlocked_ground_pound) {
//    if (at_apex && CROUCH && DOWN && ground_pound_timer <= 0) {
//        velocity_y = fall_speed_max;
//        velocity_x = 0;
//        ground_pound_timer = 180; 
//    }
//}
//if (ground_pound_timer > 0) {
//    ground_pound_timer--;
//    touched_wall = false;
//    velocity_x   = 0;
//}

////--------------------------------------------------------
//// One sided platforms => crouch + down while on platform
//// (FIXED: use 'DOWN' as a hold check, so order doesn't matter.)
////--------------------------------------------------------
//if (CROUCH && DOWN && grounded 
//    && place_meeting(x, y + 1, obj_one_sided_platform))
//{
//    var _platform = instance_nearest(x, y + 1, obj_one_sided_platform);
//    if (_platform != noone) {
//        _platform.solid_override = true;
//        _platform.alarm[1]       = 30; 
//    }
//}

//// Crouch on edge
//if (CROUCH && grounded) {
//    velocity_x *= 0.7;
//    if (place_free(position_x + 8, position_y + 16)) {
//        velocity_x = 0.0;
//    }
//    if (place_free(position_x - 8, position_y + 16)) {
//        velocity_x = 0.0;
//    }
//    _color = c_dkgray;
//}
//else {
//    _color = c_white;
//}

//// Wall climb
//if (unlocked_wall_climb) {
//    if (!grounded && touched_wall && CROUCH && grip_strength > 40) {
//        grip_strength--;
//        velocity_y = 0;
//        if (jumpPressed) {
//            grip_strength -= 40;
//            velocity_y    += jump_force;
//            if (place_free(x + 1, y)) {
//                velocity_x  = 1;
//            }
//            if (place_free(x - 1, y)) {
//                velocity_x  = -1;
//            }
//        }
//        if (jumpHold) {
//            if (R && place_free(x + 1, y)) {
//                velocity_x =  max_velocity_x;
//                velocity_y =  jump_force;
//            }
//            if (L && place_free(x - 1, y)) {
//                velocity_x = -max_velocity_x;
//                velocity_y =  jump_force;
//            }
//        }
//    }
//    if (CROUCH && grip_strength <= 40 && touched_wall) {
//        grip_strength--;
//        if (grip_strength <= 0) {
//            velocity_y += normal_fall_speed;
//        } else {
//            velocity_y = normal_fall_speed;
//        }
//    }
//}

//// 7) ACTUALIZE MOVEMENT & COLLISIONS
//if (place_free(position_x, position_y)) {
//    x = position_x;
//    y = position_y;
//}
//else {
//    var x_move_amount = position_x - x;
//    if (x_move_amount > 0) {
//        move_contact_solid(0, x_move_amount);
//    } 
//    else if (x_move_amount < 0) {
//        move_contact_solid(180, -x_move_amount);
//    }
//    var y_move_amount = position_y - y;
//    if (y_move_amount > 0) {
//        move_contact_solid(270, y_move_amount);
//    } 
//    else if (y_move_amount < 0) {
//        move_contact_solid(90, -y_move_amount);
//    }
//}

//// Sticky Feet
//if (!place_free(position_x, position_y + 1)) {
//    if (landed_frames_ago < 6) {
//        if (L && velocity_x > 0) {
//            position_x -= max_velocity_x;
//            velocity_x  = -max_velocity_x;
//        }
//        if (R && velocity_x < 0) {
//            position_x += max_velocity_x;
//            velocity_x  =  max_velocity_x;
//        }
//    }
//}

//// 8) POST MOVEMENT
//if (velocity_x < 0) {
//    facing_direction = -1;
//}
//else if (velocity_x > 0) {
//    facing_direction = 1;
//}

//// Ground check
//if (place_free(x, y + 1)) {
//    grounded = false;
//}
//else {
//    if (!grounded) {
//        landed_frames_ago = 0;
//    }
//    grounded_x = x;
//    grounded_y = y;
//    jump_count = 0;
//    grounded   = true;
//    velocity_y = 0;
//    grounded_frames_ago = 0;
//}

//grounded_frames_ago++;
//if (grounded) {
//    ground_pound_timer = 0;
//    grip_strength      = 120;
//    landed_frames_ago++;
//}

//// frames_going_down
//if ((grounded && landed_frames_ago > 2) || velocity_y < 0) {
//    frames_going_down = 0;
//}
//else if (velocity_y > 0) {
//    frames_going_down++;
//}

//// Bumped corner teleporting (while going down)
//if (velocity_y > 0) {
//    var bump_amount = 8;
//    if (velocity_x > 1) {
//        if (!place_free(x + 1, y)) {
//            if (place_free(position_x, position_y - bump_amount)) {
//                x = position_x;
//                y = position_y - (bump_amount + 1);
//                move_contact_solid(270, bump_amount + 2);
//            }
//        }
//    }
//    if (velocity_x < -1) {
//        if (!place_free(x - 1, y)) {
//            if (place_free(position_x, position_y - bump_amount)) {
//                x = position_x;
//                y = position_y - (bump_amount + 1);
//                move_contact_solid(270, bump_amount + 2);
//            }
//        }
//    }
//}

//// Bump head on corner
//if (velocity_y < 0 && !place_free(x, y - 1)) {
//    var bump_amount2 = 8;
//    if (place_free(position_x + bump_amount2, position_y - 1)) {
//        x += bump_amount2;
//        y -= 1;
//        move_contact_solid(180, bump_amount2);
//    }
//    else if (place_free(position_x - bump_amount2, position_y - 1)) {
//        x -= bump_amount2;
//        y -= 1;
//        move_contact_solid(0, bump_amount2);
//    }
//    else {
//        velocity_y = 0;
//    }
//}

//// touched_wall
//touched_wall = false;
//if (!place_free(x + 1, y) || !place_free(x - 1, y)) {
//    velocity_x = 0;
//    touched_wall = true;
//}

//// Fell out of room => reset
//if (y > room_height + 64) {
//    if (place_free(grounded_x + 8, grounded_y + 16)) {
//        grounded_x -= 8;
//    }
//    if (place_free(grounded_x + 8, grounded_y + 16)) {
//        grounded_x += 8;
//    }
//    x = grounded_x;
//    y = grounded_y;
//    stun_player = true; // or damage
//}

//// 9) MOVEMENT DEBUG (Optional)
//record_frame++;
//if (record_frame > record_count) {
//    record_frame = 0;
//}
//record_line_x[record_frame]      = x;
//record_line_y[record_frame]      = y;
//record_line_colour[record_frame] = c_white;
//if (at_apex) {
//    record_line_colour[record_frame] = c_aqua;
//}


//#endregion

//#region Combat
//if (iframes > 0) {
//    iframes--;
//}

//// example usage: obj_player.damage_health(15);
//function damage_health(amount, stun_frames = 60) {
//    if (iframes <= 0) {
//        current_health -= amount;
//        current_health = clamp(current_health, 0, total_health);
//        iframes = stun_frames;
//    }
//}
//#endregion





































/*****************************************************************
  obj_player : STEP
******************************************************************
  Features ✔
   1.  WASD-style move & gravity ✔
   2.  Coyote-time ✔
   3.  Jump-buffer
   4.  Double-jump
   5.  Momentum boost
   6.  Apex slow-fall
   7.  Celeste dash
   8.  Ground-pound (stub)
   9.  Wall-slide / climb (stub)
  10.  Sticky-feet snap (stub)
  11.  Moving-platform ride (basic)
  12.  Simple sword swing
*****************************************************************/

/* ---------- 0. INPUT (read once) ---------- */
var l          = input_check("left");
var r          = input_check("right");

var jump_press = input_check_pressed ("up")  || input_check_pressed ("accept");
var jump_rel   = input_check_released("up")  || input_check_released("accept");

var dash_press = input_check_pressed ("dash");
var atk_press  = input_check_pressed ("shoot");

/* freeze controls while stunned */
if (stun_timer > 0) {
    stun_timer--;
    l = r = 0;
    jump_press = jump_rel = dash_press = atk_press = false;
}

/* ---------- 1. HORIZONTAL ACCEL (locked while dashing) ---------- */
if (dash_state == 0) {
    if (l ^ r) {
        velocity_x = clamp(velocity_x + (r - l)*acceleration_x,
                           -max_velocity_x, max_velocity_x);
    } else if (abs(velocity_x) > 1) {
        velocity_x -= sign(velocity_x)*decceleration_x;
    } else velocity_x = 0;
}

/* ---------- 2. DASH FSM ---------- */
if (dash_press && dash_state == 0) { dash_state = 1; dash_timer = dash_freeze; }

switch (dash_state) {
case 1:  // anticipation freeze
    velocity_x = velocity_y = 0;
    if (--dash_timer <= 0) {
        dash_state = 2;
        dash_timer = dash_length;
        velocity_x = facing_direction * dash_speed_x;
    }
    break;

case 2:  // travelling
    velocity_y = 0;
    if (--dash_timer <= 0) dash_state = 0;
    break;
}

/* ---------- 3. JUMP / COYOTE / BUFFER ---------- */
if (jump_press) up_frames_ago = 0; else up_frames_ago++;

coyote_left = grounded ? coyote_frames : max(coyote_left - 1, 0);

var buffered = (up_frames_ago <= buffer_frames);
var can_jump = grounded || coyote_left > 0 || (jump_count < max_jumps);

if (buffered && can_jump) {
    up_frames_ago = buffer_frames + 1;      // consume buffer
    velocity_y    = jump_force;
    grounded      = false;
    jump_count++;
}

/* ---------- 4.  GRAVITY & SHORT-HOP CUT  ---------- */
/* we want:   ► light gravity while the player HOLDS the button
              ► heavy gravity once the button is released          */

var holding_jump = input_check("up") || input_check("accept");

if (!grounded)
{
    var g;

    // lighter gravity on ascent **while you’re holding the key**
    if (velocity_y < 0 && holding_jump)
        g = fall_speed * 0.4;   // feel-good tweak  (0.4 ≈ “floaty”)
    else
        g = fall_speed;         // normal gravity

    velocity_y = clamp(velocity_y + g,
                       fall_speed_min, fall_speed_max);
}


/* ---------- 5. SIMPLE SWORD ATTACK ---------- */
if (attack_cooldown > 0) attack_cooldown--;
if (attack_timer > 0) {
    attack_timer--;
    if (attack_timer == 3) {
        var hit_x = x + facing_direction*10;
        var hit_y = y - 4;
        instance_create_layer(hit_x, hit_y, "Instances", obj_attack);
    }
} else if (atk_press && attack_cooldown == 0 && grounded) {
    attack_timer    = 6;
    attack_cooldown = 15;
}

/* ---------- 6. VERY BASIC MOVING-PLATFORM SNAP ---------- */
var elev = instance_place(x, bbox_bottom + 1, obj_vertical_moving_platform);
if (elev != noone && velocity_y >= 0 && !jump_press) {
    y = elev.bbox_top - (bbox_bottom - bbox_top);
    y += elev.dy;
    velocity_y = max(0, elev.dy);   // follow only downward
    grounded   = true;
}

/* ---------- 7. INTEGRATE & COLLIDE (AABB) ---------- */
var nx = x + velocity_x;
var ny = y + velocity_y;

if (place_free(nx, y)) x = nx; else velocity_x = 0;
if (place_free(x, ny)) y = ny; else velocity_y = 0;

/* ---------- 8. GROUND REFRESH & COUNTERS ---------- */
grounded = !place_free(x, y + 1);
if (grounded) { velocity_y = 0; jump_count = 0; }
if (velocity_y > 0) frames_going_down++;

/* ---------- 9. I-FRAME BLINK DEBUG ---------- */
if (iframes > 0) { iframes--; image_alpha = (iframes div 5) mod 2; }
else image_alpha = 1;

/* ---------- 10. UPDATE TRAIL ARRAYS (Draw uses these) ---------- */
record_line_x[record_frame]      = x;
record_line_y[record_frame]      = y;
record_line_colour[record_frame] = (velocity_y < 0 ? c_aqua : c_white);

record_frame = (record_frame + 1) mod record_count;

/* helper aliases for the Draw event */
position_x = x;
position_y = y;
