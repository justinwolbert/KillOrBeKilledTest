///// obj_spikes «collision with» obj_player
//var dmg = spike_damage;
//var vy  = knockback_vy;
//var vx  = knockback_h;

//if (other.iframes <= 0)
//{
//    /* hurt + 0.75-s i-frames */
//    other.damage_health(dmg, 45);
//    other.iframes    = 45;
//    other.stun_timer = 15;       // short input lock

//    /* choose safe side (left or right) by centre-point) */
//    var dir = (other.x < x) ? -1 : 1;   // based on origin only

//    // start just outside the spike row so we're not overlapping
//    if (dir == -1)
//         other.x = x - other.sprite_width - 1;
//    else other.x = x + sprite_width + 1;

//    other.velocity_x = dir * vx;
//    other.velocity_y = vy;

//}






/// obj_spikes «collision with» obj_player
var dmg = spike_damage;
var vy  = knockback_vy;
var vx  = knockback_h;

if (other.iframes <= 0)
{
    // Determine if the player will survive the hit before applying damage
    var survives = (other.current_health > dmg);

    /* hurt + 0.75-s i-frames */
    other.damage_health(dmg, 45);
 
    // Only apply knockback if player is still alive after taking damage
    if (survives)
    {
        other.stun_timer = 15;       // short input lock

        /* choose safe side (left or right) by centre-point */
        var dir = (other.x < x) ? -1 : 1;   // based on origin only
		
		
		        // start just outside the spike row so we're not overlapping
        if (dir == -1)
             other.x = x - other.sprite_width - 1;
        else other.x = x + sprite_width + 1;

        other.velocity_x = dir * vx;
        other.velocity_y = vy;
    }
}