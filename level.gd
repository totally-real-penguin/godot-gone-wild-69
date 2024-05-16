extends Node2D


@export var room: PackedScene
@export var empty: PackedScene

func _ready():
	$Camera.zoom.x /= Global.scale_factor
	$Camera.zoom.y /= Global.scale_factor
	generate_rooms(60)

func generate_rooms(rooms_required):
	var room_queue = [$"Tile(0, 0)"]
	var rooms_generated = 1
	while room_queue != []:
		var current_room = room_queue[0]
		current_room.neighbours = check_neighbours(current_room)
		var available_directions = []
		var num_directions = 0
		
		
		for i in range(0,4):
			if current_room.neighbours[i] == null:
				available_directions.append(true)
				num_directions += 1
			else:
				available_directions.append(false)
				if current_room.neighbours[i].is_in_group("room"):
					check_neighbours(current_room.neighbours[i])
		
		var new_rooms = new_rooms_weight(num_directions,current_room.distance)
		for i in range(0,new_rooms):
			var room_direction = randi_range(1,(num_directions))
			if rooms_generated < rooms_required:
				for j in range(0,4):
					if available_directions[j] == true:
						room_direction -= 1
						
					if room_direction == 0:
						var new_tile = create_tile(current_room,j,room)
						add_child(new_tile)
						new_tile.set_color()
						room_queue.append(new_tile)
						rooms_generated += 1
						available_directions[j] = false
						num_directions -= 1
						break
		for i in range(0,4):
			if available_directions[i] == true:
				add_child(create_tile(current_room,i,empty))
				available_directions[i] = false
		room_queue.pop_front()

func create_tile(current_room,direction,tile):
	var tile_instance = tile.instantiate()
	var tile_positions = [
		Vector2i(current_room.grid_pos.x ,current_room.grid_pos.y -1), #Up
		Vector2i(current_room.grid_pos.x + 1,current_room.grid_pos.y), #Right
		Vector2i(current_room.grid_pos.x ,current_room.grid_pos.y +1), #Down
		Vector2i(current_room.grid_pos.x - 1 ,current_room.grid_pos.y)] #Left
	tile_instance.grid_pos = tile_positions[direction]
	tile_instance.position.x = tile_instance.grid_pos.x * Global.scale_factor * 4 # times 4 because its the size of the sprite
	tile_instance.position.y = tile_instance.grid_pos.y * Global.scale_factor * 4 # times 4 because its the size of the sprite
	tile_instance.distance = current_room.distance + 1
	tile_instance.name = "Tile" + str(tile_instance.grid_pos)
	return tile_instance

func check_neighbours(current_room):
	var grid_pos = current_room.grid_pos
	var neighbours = []
	var neighbours_pos = [
		Vector2i(grid_pos.x ,grid_pos.y -1), #Up
		Vector2i(grid_pos.x + 1,grid_pos.y), #Right
		Vector2i(grid_pos.x ,grid_pos.y +1), #Down
		Vector2i(grid_pos.x - 1 ,grid_pos.y)] #Left
	for i in range(0,4):
		neighbours.append(get_node_or_null("Tile" + str(neighbours_pos[i])))
		if has_node(("Tile" + str(neighbours_pos[i]))):
			if get_node_or_null("Tile" + str(neighbours_pos[i])).is_in_group("room") == true:
				if i == 0:
					current_room.get_node("up").visible = true
				if i == 1:
					current_room.get_node("right").visible = true
				if i == 2:
					current_room.get_node("down").visible = true
				if i == 3:
					current_room.get_node("left").visible = true
	return neighbours

func new_rooms_weight(directions,distance):
	if distance >= 4:
		return 1
	elif distance >= 2:
		if directions < 2:
			return randi_range(1,directions)
		else:
			return randi_range(1,2)
	elif distance >= 1:
		if directions < 3:
			return randi_range(1,directions)
		else:
			return randi_range(1,3)
	elif distance == 0:
		return randi_range(2,4)
