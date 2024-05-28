extends Node2D

@export var room: PackedScene
@export var empty: PackedScene

@onready var room_queue : Array = [$"tile(0, 0)"]
@onready var current_room : Node = room_queue[0]
var rooms_generated : int = 1
var rng : RandomNumberGenerator = Global.rng
var room_size : Vector2i = Vector2i(640,560)
var room_weights : Array = [5,3,1]

func _process(_delta):
	$camera.position.x = $character.grid_pos.x * room_size.x
	$camera.position.y = $character.grid_pos.y * room_size.y

func _ready():
	generate_rooms(12)

func generate_rooms(rooms_required):
	while room_queue != []:
		current_room = room_queue[0]
		current_room.neighbours = check_neighbours(current_room)
		var available_directions : Array = []
		var num_directions : int = 0
		
		for i in range(0,4):
			if current_room.neighbours[i] == null:
				available_directions.append(true)
				num_directions += 1
			else:
				available_directions.append(false)
				if current_room.neighbours[i].is_in_group("room"):
					current_room.neighbours[i].neighbours = check_neighbours(current_room.neighbours[i])
					current_room.neighbours[i].open_doors()
		if num_directions == 0:
			print(current_room.name + " has no space to go")
			room_queue.pop_front()
			continue
		
		var new_rooms : int = new_rooms_weight(num_directions,current_room.distance,room_weights)
		
		for i in range(0,new_rooms):
			var room_direction : int = rng.randi_range(1,(num_directions))
			if rooms_generated < rooms_required:
				for j in range(0,4):
					if available_directions[j] == true:
						room_direction -= 1
						
					if room_direction == 0:
						var new_tile : Node = create_tile(current_room,j,room)
						add_child(new_tile)
						room_queue.append(new_tile)
						rooms_generated += 1
						available_directions[j] = false
						num_directions -= 1
						break
		for i in range(0,4):
			if available_directions[i] == true:
				add_child(create_tile(current_room,i,empty))
				available_directions[i] = false
		current_room.open_doors()
		room_queue.pop_front()

func create_tile(c_room:Node, direction:int, tile:PackedScene) -> Node:
	var grid_pos = c_room.grid_pos
	var tile_instance = tile.instantiate()
	var tile_positions = [
		Vector2i(grid_pos.x ,grid_pos.y - 1), #Up
		Vector2i(grid_pos.x + 1,grid_pos.y), #Right
		Vector2i(grid_pos.x, grid_pos.y +1), #Down
		Vector2i(grid_pos.x - 1 ,grid_pos.y)] #Left
	
	tile_instance.grid_pos = tile_positions[direction]
	tile_instance.position.x = tile_instance.grid_pos.x * room_size.x
	tile_instance.position.y = tile_instance.grid_pos.y * room_size.y
	tile_instance.distance = current_room.distance + 1
	tile_instance.name = "tile" + str(tile_instance.grid_pos)
	
	
	if tile == room:
		var hue = ((140.0 - (7 * tile_instance.distance)) / 360.0)
		$camera/minimap.create_minimap_tile(tile_instance.grid_pos, Color.from_hsv(hue,1,1))
	else:
		$camera/minimap.create_minimap_tile(tile_instance.grid_pos, Color.from_hsv(0,0,0))
	
	return tile_instance

func check_neighbours(c_room:Node) -> Array:
	var grid_pos = c_room.grid_pos
	var neighbours = []
	var neighbours_pos = [
		Vector2i(grid_pos.x, grid_pos.y -1), #Up
		Vector2i(grid_pos.x + 1, grid_pos.y), #Right
		Vector2i(grid_pos.x, grid_pos.y +1), #Down
		Vector2i(grid_pos.x - 1, grid_pos.y)] #Left
	for i in range(0,4):
		neighbours.append(get_node_or_null("tile" + str(neighbours_pos[i])))
	return neighbours

func new_rooms_weight(directions:int, distance:int, weights:Array) -> int:
	if distance >= weights[0]:
		return 1
	
	elif distance >= weights[1]:
		if directions < 2:
			return rng.randi_range(1,directions)
		else:
			return rng.randi_range(1,2)
	
	elif distance >= weights[2]:
		if directions < 3:
			return rng.randi_range(1,directions)
		else:
			return rng.randi_range(1,3)
	
	elif distance == 0:
		return rng.randi_range(2,4)
	else:
		print("Bounds don't cover " + str(distance))
		return rng.randi_range(1,directions)
