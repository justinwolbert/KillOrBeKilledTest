/*──────────────────────────────────────────────────────────────
  obj_player : CREATE
  All tweak-numbers are grouped at the top ↓
──────────────────────────────────────────────────────────────*/

/* === movement tuning === */
acceleration_x  = 1;
decceleration_x = 1;
max_velocity_x  = 5;

fall_speed      = 1.2;
fall_speed_min  = -20;
fall_speed_max  = 9.6;
jump_force      = -10;

/* === jump QoL === */
coyote_frames   = 8;     // grace frames after leaving floor
buffer_frames   = 7;     // jump-buffer window
max_jumps       = 1;     // 1 ⇒ no double-jump

/* === dash (Celeste style) === */
dash_freeze   = 3;               // anticipation
dash_length   = 12;              // travel frames
dash_speed_x  = max_velocity_x*2;

/* === live state vars === */
velocity_x = 0;
velocity_y = 0;
grounded   = false;

coyote_timer       = 0;
frames_since_jump_press     = buffer_frames + 1;
jump_count        = 0;
frames_falling = 0;

dash_state = 0;   // 0 idle • 1 freeze • 2 dash
dash_timer = 0;

attack_timer    = 0;
attack_cooldown = 0;

iframes    = 0;
stun_timer = 0;

facing_direction = 1;   // 1 → right, -1 → left

/* === vars referenced by Draw === */
_color       = c_white;
image_alpha  = 1;

/* === debug trail arrays (Draw uses these) === */
record_count       = 150;
record_frame       = 0;
record_line_x      = array_create(record_count, x);
record_line_y      = array_create(record_count, y);
record_line_colour = array_create(record_count, c_white);

/* === HUD === */
gui_health_width      = display_get_gui_width()*0.25;
half_gui_health_width = gui_health_width*0.5;
current_health        = 100;
total_health          = 100;

/* helper aliases for Draw’s debug rectangles */
position_x = x;
position_y = y;

////  Player-only version
//damage_health = function (_amt, _kb_h = 4, _kb_v = -4, _stun = 18)
//{
//    if (iframes > 0) exit;
//    current_health = clamp(current_health - _amt, 0, total_health);

//    iframes    = _stun;
//    stun_timer = _stun;

//    var dir = sign(x - other.x);       // away from hitter
//    velocity_x = clamp(_kb_h * dir, -max_velocity_x*0.8, max_velocity_x*0.8);
//    velocity_y = _kb_v;
//};

















/// knock-back + red-blink damage routine
/// damage_health(amount,
///               kb_h = 3,          // horizontal knock-back
///               kb_v = -2,         // vertical knock-back
///               invul_sec = 3      // seconds of invulnerability
///              )
damage_health = function (_amt,
                          _kb_h      = 3,
                          _kb_v      = -2,
                          _invul_sec = 3)
{
    // already blinking?  then ignore hit
    if (iframes > 0) exit;
    
    // 1) subtract HP
    current_health = clamp(current_health - _amt, 0, total_health);
    
    // 2) give knock-back – very mild
    var dir = sign(x - other.x);          // push away from attacker
    velocity_x = _kb_h * dir;
    velocity_y = _kb_v;

    // 3) start invulnerability timer (frames)
    iframes    = _invul_sec * room_speed;   // e.g. 3 s × 60 fps = 180 frames
    blink_red  = true;                     // flag for draw code
};


