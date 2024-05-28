extends Node2D

func _ready():
	create_minimap_tile(Vector2(0,0), Color.from_hsv(0,0,1))

func create_minimap_tile(grid_pos: Vector2i,color : Color):
	var size := Vector2i(12,10)
	var tile = ColorRect.new()
	tile.size = size
	tile.position.x = (grid_pos.x * size.x) + 64
	tile.position.y = (grid_pos.y * size.y) + 64
	tile.color = color
	tile.name = "minimap" + str(grid_pos)
	self.add_child(tile)
