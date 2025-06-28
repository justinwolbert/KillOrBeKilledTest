if (input_check("test"))
{
	draw_line_color(x,y+10,x+18,y+10,c_red,c_red);
}

image_xscale = facing_direction;
draw_sprite_ext(sprite_index, image_index, 
	round(x), round(y),
	image_xscale, image_yscale, 
	image_angle, _color, image_alpha);

// Draw mask
draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, true);

#region movement debug
draw_rectangle(position_x+8, position_y+32, position_x+8, position_y+32, true);
draw_rectangle(position_x-8, position_y+32, position_x-8, position_y+32, true);
for (var i = 0; i < record_count-1; ++i) {
	if (i != record_frame) {
	    draw_set_colour(record_line_colour[i])
		draw_line(record_line_x[i],record_line_y[i],
		record_line_x[i+1],record_line_y[i+1])
	} else {
		draw_set_colour(record_line_colour[record_count-1])
		draw_line(record_line_x[record_count-1],record_line_y[record_count-1],record_line_x[0],record_line_y[0])
	}
}
if (input_check_pressed("test"))
{
	x = x_start;
	y = y_start;
}
#endregion

#region enemy damage
//if (iframes > 0 && (iframes div 5) mod 2 == 0) exit;   // << new line
//draw_self();                                           // (your old draw code)

#endregion
