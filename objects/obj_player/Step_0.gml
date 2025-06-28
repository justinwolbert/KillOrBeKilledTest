//  obj_player : STEP
//******************************************************************
//  Features ✔
//   1.  WASD-style move & gravity ✔
//   2.  Coyote-time ✔
//   3.  Jump-buffer ✔
//   4.  Momentum boost ✔
//   5.  Apex slow-fall
//   6.  Celeste dash ✔
//   7.  Ground-pound (stub)
//   8.  Wall-slide / climb (stub)
//   9.  Moving-platform ride (basic)
//  10.  Simple sword swing
//  11.  Crouch ✔ 



/// obj_player Step Event – Refactored movement logic

/* 0. Read and Prepare Input */
var move_left   = input_check("left");    // horizontal input (left)
var move_right  = input_check("right");   // horizontal input (right)
var jump_pressed   = input_check_pressed("up")  || input_check_pressed("accept");
var jump_released  = input_check_released("up") || input_check_released("accept");
var dash_pressed   = input_check_pressed("dash");
var attack_pressed = input_check_pressed("shoot");
var crouch_held = input_check("crouch");

// If player is stunned, decrement timer and ignore all inputs
if (stun_timer > 0) {
    stun_timer--;
    move_left = move_right = 0;
    jump_pressed = jump_released = false;
    dash_pressed = false;
    attack_pressed = false;
}

/* 1. Horizontal Movement (only when not dashing) ---------------*/
/*  ‣  If the Ctrl-key is held (crouch_held = true)
    we run at 50 % speed: both the acceleration     (ax)
    and the top speed (mx) are halved.                         */

var ax = acceleration_x;   // default values
var mx = max_velocity_x;

if (crouch_held) {
    ax *= 0.5;             // slower acceleration
    mx *= 0.5;             // lower speed-cap
}

if (dash_state == 0) {
    if (move_left  && !move_right) {
        velocity_x = clamp(velocity_x - ax, -mx, mx);
    }
    else if (move_right && !move_left) {
        velocity_x = clamp(velocity_x + ax, -mx, mx);
    }
    else {
        // no input or both keys – glide to a stop
        if (abs(velocity_x) > 1)  velocity_x -= sign(velocity_x) * decceleration_x;
        else                      velocity_x  = 0;
    }
}

/* 2. Dash State Machine */
if (dash_pressed && dash_state == 0) { 
    // initiate dash (enter anticipation state)
    dash_state = 1;
    dash_timer = dash_freeze;  // dash_freeze: frames to pause (anticipation)
}
switch (dash_state) {
	case 1: // anticipation
    if (--dash_timer <= 0) {
        dash_state = 2;
        dash_timer = dash_length;
        velocity_x = facing_direction * dash_speed_x;

        iframes = dash_length;
        screen_shake(4, 8);
    }
    break;

	case 2:  // active dash
    velocity_y = 0;

    // —— NEW way: drop a dedicated ghost ——
    var g = instance_create_layer(x, y, layer, obj_dashGhost);
    g.sprite_index   = sprite_index;   // copy current sprite frame
    g.image_index    = image_index;
    g.image_angle    = image_angle;
    g.image_xscale   = image_xscale;
    g.image_yscale   = image_yscale;
    g.image_blend    = _color;         // keep crouch tint if any
    // ————————————————————————————————

    if (--dash_timer <= 0) dash_state = 0;
    break; }

/* 3. Jumping (unified jump, coyote time, buffering, double-jump) */
// Track how many frames since jump was pressed (for buffering)
if (jump_pressed) {
    frames_since_jump_press = 0;
} else {
    frames_since_jump_press++;
}
// Decrease coyote-time counter if not grounded
coyote_timer = (grounded) ? coyote_frames : max(coyote_timer - 1, 0);

//  block jumping while crouched
// ----------------------------------------------------------------
if (crouch_held) {
    /* while crouched we:                               
       1) forbid any jump this frame                  */  
    var can_jump_override = false;
    /* 2) clear the buffer so you don’t “store up” a press
       that would fire the moment you release crouch  */  
    frames_since_jump_press = buffer_frames + 1;
}

// Determine if a jump can occur (on ground, or coyote-time, or extra jumps left)
var jump_buffered = (frames_since_jump_press <= buffer_frames);
var can_jump      = (grounded || coyote_timer > 0 || jump_count < max_jumps);
if (jump_buffered && can_jump) {
    // Consume the buffered jump input and perform jump
    frames_since_jump_press = buffer_frames + 1;  // reset buffer window
    velocity_y    = jump_force;                   // apply immediate upward force
    grounded      = false;
    jump_count++;
}

/* 4. Gravity and Short-Hop (variable jump height) */
if (!grounded) {
    // Determine gravity amount: lighter if ascending while holding jump
    var gravity_force;
    var holding_jump = input_check("up") || input_check("accept");
    if (velocity_y < 0 && holding_jump) {
        gravity_force = fall_speed * 0.4;   // lighter gravity when rising (floatier jump)
    } else {
        gravity_force = fall_speed;         // normal gravity (falling or not holding jump)
    }
    // Apply gravity (clamped between terminal velocities)
    velocity_y = clamp(velocity_y + gravity_force, fall_speed_min, fall_speed_max);
}

/* 5. Attack (simple sword swing) */
if (attack_cooldown > 0) {
    attack_cooldown--;
}
if (attack_timer > 0) {
    attack_timer--;
    if (attack_timer == 3) {
        // create hitbox in front of player on 3rd frame of swing
        var hit_x = x + facing_direction * 10;
        var hit_y = y - 4;
        instance_create_layer(hit_x, hit_y, "Instances", obj_attack);
    }
} else if (attack_pressed && attack_cooldown == 0 && grounded) {
    // start a new attack (only if on ground and not in cooldown)
    attack_timer    = 6;   // total attack animation frames
    attack_cooldown = 15;  // frames before next attack can start
}

/* 6. Moving Platform Adjustment */
var platform = instance_place(x, bbox_bottom + 1, obj_vertical_moving_platform);
if (platform != noone && velocity_y >= 0 && !jump_pressed) {
    // Snap player to the platform if standing on it (platform moving down or stationary)
    y = platform.bbox_top - (bbox_bottom - bbox_top);  // stick to platform top
    y += platform.dy;                                  // carry along vertical movement
    velocity_y = max(0, platform.dy);   // if platform goes down, follow; if up, don't drag player
    grounded   = true;
}

/* 7. Integrate Movement and Handle Collisions */
var new_x = x + velocity_x;
var new_y = y + velocity_y;

/* ---- Crouch edge-prevention ---- */
if (crouch_held)
{
    // Is there ground one pixel below the spot we’re about to step onto?
    if (place_free(new_x, y + 1))
    {
        // nothing beneath → cancel horizontal movement
        new_x      = x;     // stay in place
        velocity_x = 0;     // zero out h-speed for this frame
    }
}

// Move horizontally if no obstacle, otherwise stop horizontal velocity
if (place_free(new_x, y)) {
    x = new_x;
} else {
    velocity_x = 0;
}
// Move vertically if no obstacle, otherwise stop vertical velocity
if (place_free(x, new_y)) {
    y = new_y;
} else {
    velocity_y = 0;
}

/* 8. Update Grounded State and Facing Direction */
grounded = !place_free(x, y + 1);   // standing on something?
if (grounded) {
    velocity_y = 0;
    jump_count = 0;                 // reset extra jumps when landed
}
// Update facing_direction based on movement direction (for sprite facing)
if (velocity_x < 0) {
    facing_direction = -1;
} else if (velocity_x > 0) {
    facing_direction = 1;
}
// Track falling frames (for potential future use in early-fall mechanics)
if (velocity_y > 0) {
    frames_falling++;
} else {
    frames_falling = 0;
}

/* 9. Invincibility Frames (blink effect) */
if (iframes > 0)
{
    iframes--;

    // --- colour flash only if this is DAMAGE invul, not dash invul
    if (blink_red)
    {
        if ((iframes div 4) mod 2 == 0)
            _color = c_red;
        else
            _color = c_white;
    }
}
else
{
    blink_red = false;     // reset flag once timer expires
    _color    = c_white;   // ensure colour back to normal
}


/* 10. Debug: Record Trail (position history for drawing) */
record_line_x[record_frame]      = x;
record_line_y[record_frame]      = y;
record_line_colour[record_frame] = (velocity_y < 0 ? c_aqua : c_white);
record_frame = (record_frame + 1) mod record_count;

/* 11. Crouch:
/* ───── simple crouch-visual ───── */
if (crouch_held)
{
    // dark-grey tint while crouching
    _color = c_dkgray; 
}

