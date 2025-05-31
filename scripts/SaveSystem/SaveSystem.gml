// Script: SaveSystem
global.game_data =
{
	level: 1,
	room_data: {}
}

function save_room()
{
	var _array = [];
// Duplicate this With block for each object you want to save	
	with (obj_player) {
		var _struct =
		{
			object: object_get_name(object_index),
			x: x,
			y: y,
		};
		array_push(_array, _struct);
	}
// For example, obj_camera	
	with (obj_camera) {
		var _struct =
		{
			object: object_get_name(object_index),
			x: x,
			y: y,
			camera_x: camera_x,
			camera_y: camera_y,
		};
		array_push(_array, _struct);
	}
	struct_set(global.game_data.room_data, room_get_name(room), _array);
}


function save_game(){
	save_room();
	var _string = json_stringify(global.game_data);
	var _file = file_text_open_write("save.txt");
	file_text_write_string(_file, _string);
	file_text_close(_file);
}

function load_room() {
	var _array = struct_get(global.game_data.room_data, room_get_name(room));	
	if (_array != undefined)
	{
		instance_destroy(obj_camera);
		instance_destroy(obj_player);
		for ( var i = 0; i < array_length(_array); i += 1)
		{
			var _struct = _array[i];
			// instance Create layer assumes _struct variables have the same name as the create event of the object.
			instance_create_layer(_struct.x, _struct.y, "Instances", asset_get_index(_struct.object), _struct);
			print($"struct obj name: {_struct.object}");
		}
	}
}

function load_game(){
	if (file_exists("save.txt"))
	{
		var _file = file_text_open_read("save.txt");
		var _json = file_text_read_string(_file);
		global.game_data = json_parse(_json);
		load_room();
		file_text_close(_file);
	}
}