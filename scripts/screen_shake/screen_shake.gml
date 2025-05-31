/// screen_shake(magnitude, frames)
///
/// magnitude  – how many pixels to shake in X & Y (e.g. 8)
/// frames     – how many frames to shake (e.g. 15)

if (argument_count < 2) exit;

global._shake_mag   = argument0;
global._shake_time  = argument1;
