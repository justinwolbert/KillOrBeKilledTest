// Default
platform_dx = 0;
var oldx = x;   // track previous position

// Calculate intended movement
var proposed_dx = hsp * move_dir;

// Check for solid wall ahead
var inst = instance_place(x + proposed_dx, y, all);

if (inst != noone && inst.solid) {
    // Hit wall — reverse
    move_dir *= -1;

    // Try new direction
    proposed_dx = hsp * move_dir;
    inst = instance_place(x + proposed_dx, y, all);

    if (inst == noone || !inst.solid) {
        x += proposed_dx;
    }
    // Else: still blocked — don't move
} else {
    // No collision — move and store movement
    x += proposed_dx;
}
   
// Amount moved this frame
platform_dx = x - oldx;

// If platform overlapped the player, push them out
if (platform_dx != 0) {
    var _player = instance_place(x, y, obj_player);
    if (_player != noone) {
        _player.x += platform_dx;
        while (place_meeting(_player.x, _player.y, id)) {
            _player.x += sign(platform_dx);
        }
    }

}




