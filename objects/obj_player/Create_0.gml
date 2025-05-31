//////////////////////////////////////////////
//// CREATE EVENT
//////////////////////////////////////////////

//#region Movement

//// Basic horizontal movement
//acceleration_x   = 1;
//decceleration_x  = 1;
//velocity_x       = 0;
//max_velocity_x   = 5.0;
//_max_velocity_x  = max_velocity_x; // used for coyote boost lerp
//coyote_boost     = max_velocity_x * 1.5;

//// Gravity & jump
//velocity_y        = 0;
//fall_speed        = 1.2;
//fall_speed_max    = 9.6;
//fall_speed_min    = -20.0;
//normal_fall_speed = 0.6;
//apex_fall_speed   = 0.4;
//apex_threshold    = 3;    // smaller => "tighter" apex detection
//jump_force        = -10.0;

//// Momentum jump & double jump
//unlocked_double_jump  = false; // can set true if you want to test
//momentum_timer        = 0;
//jump_count            = 0;
//max_jumps             = 2;     // if unlocked_double_jump = true

//// Ground pound & wall climb
//unlocked_ground_pound = true; // turn off if you like
//unlocked_wall_climb   = true;
//ground_pound_timer    = 0;
//grip_strength         = 120;

//// Position tracking
//position_x   = x;
//position_y   = y;
//grounded_x   = x;
//grounded_y   = y;

//// Coyote boosting
//coyote_boost_timer = -1;

//// “State” of being grounded, apex, etc.
//at_apex          = false;
//grounded         = false;
//touched_wall     = false;
//stun_player      = false; // or true if you want to start stunned
//stun_timer = 0;
//respawn_x  = x;
//respawn_y  = y;


//// Frame counters
//iframes            = 0;
//grounded_frames_ago= 999;
//landed_frames_ago  = 999;
//apex_frames_ago    = 999;
//UP_frames_ago      = 999;
//frames_going_down  = 999;

//// (Using c_dkgray is a built‐in color in GMS)
//_color = c_dkgray;

//// ==========================
//// DASH variables (Celeste style)
//// ==========================
//#macro DASH_ANTICIPATION 3   // frames of freeze
//#macro DASH_DURATION     12  // frames of actual dash

//dash_state = 0; // 0=not dashing, 1=anticipation, 2=dashing
//dash_timer = 0;

//#endregion

//#region movement debug
//record_count = 150;
//record_frame = 0;
//record_line_x = array_create(record_count, x);
//record_line_y = array_create(record_count, y);
//record_line_colour = array_create(record_count, c_white);
//#endregion

//#region Combat
//gui_health_width      = display_get_gui_width() * 0.25;
//half_gui_health_width = gui_health_width * 0.5;
//current_health        = 100;
//total_health          = 100;
//#endregion


///* --- melee attack vars --- */
//attack_timer   = 0;   // counts frames of the current swing
//attack_cooldown= 0;   // prevents spam


















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
max_jumps       = 2;     // 1 ⇒ no double-jump

/* === dash (Celeste style) === */
dash_freeze   = 3;               // anticipation
dash_length   = 12;              // travel frames
dash_speed_x  = max_velocity_x*2;

/* === live state vars === */
velocity_x = 0;
velocity_y = 0;
grounded   = false;

coyote_left       = 0;
up_frames_ago     = buffer_frames + 1;
jump_count        = 0;
frames_going_down = 0;

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


