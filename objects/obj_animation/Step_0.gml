/*
if ( keyboard_check_pressed(ord("T")) ) {
	toggle = !toggle;
	if (toggle == true) 
	{	
		seq = layer_sequence_create(layer_get_id("sequences"),camera_get_view_width(view_camera[0]),camera_get_view_height(view_camera[0]), sq_title);
		layer_sequence_play(seq)
	} else 
	{
		if (layer_sequence_exists(layer_get_id("sequences"), seq)) 
		{
			layer_sequence_destroy(seq);
		}
	}
}
*/