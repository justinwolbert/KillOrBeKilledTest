#region Vertical Force
velocity_y += fall_speed;
if (!place_meeting(x, y+1, [obj_one_sided_platform, obj_collision_wall]))
{
    position_y += velocity_y;
    // move_contact_solid(90,10);
}
else
{
    velocity_y = 0;
}
#endregion // Vertical Force

#region Patrol
//TODO: Abstract this into a patrol code.
if (facing_direction == 1)
{
	position_x += 2;
	if (!place_meeting(bbox_right+1,bbox_bottom+1,obj_collision_wall))
	{
		facing_direction = -1;
	}
}
else
{
	position_x -= 2;
	if (!place_meeting(bbox_left-1,bbox_bottom+1,obj_collision_wall))
	{
		facing_direction = 1;
	}
}
#endregion // Patrol

#region Actualize Movement
x = position_x;
y = position_y;
#endregion // Actualize Movement
