// Default
platform_dx = 0;

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
        platform_dx = proposed_dx;
    }
    // Else: still blocked — don't move
} else {
    // No collision — move and store movement
    x += proposed_dx;
    platform_dx = proposed_dx;
}
   

