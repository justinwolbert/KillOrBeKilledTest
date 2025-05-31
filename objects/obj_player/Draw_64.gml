//GUI Health Bar
//TODO: Juice feature - If player doesn't move for 5 seconds, fade gui out. Fade in as soon as movement
var gui_health = clamp(gui_health_width*(current_health/total_health),0,gui_health_width);
#macro GUI_HOFFSET 16
draw_sprite_stretched(spr_box, 0, 16,16, gui_health_width, 24);
draw_sprite_stretched(spr_health, 0, 20,20, gui_health-8, 16);
draw_set_font(fnt_BitPap);
draw_set_color(c_white);
draw_set_alpha(0.85);

draw_text_ext(half_gui_health_width,18,$"{current_health}",5,50)
draw_set_alpha(1);