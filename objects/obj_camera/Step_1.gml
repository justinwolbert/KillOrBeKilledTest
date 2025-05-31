// obj_camera : Step-Begin

/* ---------- follow target ---------- */
if (follow != noone) {
    xTo = follow.x;
    yTo = follow.y;
}

past_x = x;
past_y = y;

x += (xTo - x) * 0.05;
y += (yTo - y) * 0.05;

post_x = x;
post_y = y;

x = clamp(x, half_width,  room_width  - half_width);
y = clamp(y, half_height, room_height - half_height);

camera_x = x - half_width;
camera_y = y - half_height;

/* fast-falloff pixel rounding */
if (abs(post_x - past_x) < 0.005) camera_x = round(camera_x);
if (abs(post_y - past_y) < 0.005) camera_y = round(camera_y);

/* ---------- APPLY SHAKE OFFSETS HERE ---------- */
camera_set_view_pos(
    view_camera[0],
    camera_x + global._shake_off_x,
    camera_y + global._shake_off_y
);

/* ---------- parallax layers ---------- */
var bk_y     = clamp(camera_y, 0, half_height - 160);
var x_offset = (current_time * 0.01) % 288;

layer_x(BK7, camera_x * 0.5);  layer_y(BK7, bk_y * 0.2 + 152);
layer_x(BK6, camera_x * 0.6);  layer_y(BK6, bk_y * 0.6 + 138);
layer_x(BK5, camera_x * 0.7);  layer_y(BK5, bk_y * 0.9 + 122);
layer_x(BK4, camera_x * 1.1);  layer_y(BK4, bk_y * 1.1);
layer_x(BK3, camera_x * 1.1);  layer_y(BK3, bk_y * 1.1);
layer_x(BK2, camera_x * 0.9 - x_offset); layer_y(BK2, bk_y - 40);
layer_x(BK1, camera_x);        layer_y(BK1, bk_y);
