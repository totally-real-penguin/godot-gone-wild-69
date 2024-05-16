extends Node2D

var grid_pos = Vector2i(0,0)
var distance = 0
var color
var neighbours = [
	null, #up
	null, #right
	null, #down
	null] #left

func _ready():
	self.scale.x *= Global.scale_factor
	self.scale.y *= Global.scale_factor
	set_color()

func set_color():
	if distance != 0:
		if distance >= 14:
			$bg_color.color = Color.from_hsv(0.0,1.0,1.0)
		else:
			color = ((140.0 - (10 * distance)) / 360.0)
			$bg_color.color = Color.from_hsv(color,1.0,1.0)
