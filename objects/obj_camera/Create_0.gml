// obj_camera : Create

cam_width  = camera_get_view_width (view_camera[0]);
half_width = cam_width * 0.5;
cam_height = camera_get_view_height(view_camera[0]);
half_height = cam_height * 0.5;
camera_set_view_border(view_camera[0], half_width, half_height);

follow = obj_player;

xTo = x;
yTo = y;

camera_x = x - half_width;
camera_y = y - half_height;

/* fast-falloff helpers */
past_x = x;  post_x = x;
past_y = y;  post_y = y;

/* parallax layer ids*/
BK7 = layer_get_id("BK7");
BK6 = layer_get_id("BK6");
BK5 = layer_get_id("BK5");
BK4 = layer_get_id("BK4");
BK3 = layer_get_id("BK3");
BK2 = layer_get_id("BK2");
BK1 = layer_get_id("BK1");

/* make sure shake globals exist even before obj_cam_shake */
global._shake_off_x = 0;
global._shake_off_y = 0;
