extends Node2D

var grid_pos = Vector2i(0,0)
var distance = 0

func _ready():
	self.scale.x *= Global.scale_factor
	self.scale.y *= Global.scale_factor
