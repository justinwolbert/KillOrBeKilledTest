///  obj_vertical_moving_platform : Create
y_start  = y;          // top stop
y_end    = y + 305;    // bottom stop  (tweak per instance)

move_state = 0;        // 0 idle-top • 1 down • 2 idle-bottom • 3 up

/* Slam parameters */
vsp            = 0;    // current vertical speed
accel_down     = 0.4;  // how fast it picks up speed
max_speed_down = 8;    // terminal slam speed
brake_distance = 16;   // start braking this many pixels above y_end

dy = 0;                // delta-y – player uses this





