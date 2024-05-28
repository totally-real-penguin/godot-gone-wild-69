extends Node2D

var grid_pos : Vector2i = Vector2i(0,0)
var distance : int = 0
var color : float
var neighbours : Array = [
	null, #up
	null, #right
	null, #down
	null] #left

func set_color():
	if distance != 0:
		if distance >= 20:
			$bg_color.color = Color.from_hsv(0.0,1.0,1.0)
		else:
			color = ((140.0 - (7 * distance)) / 360.0)
			$bg_color.color = Color.from_hsv(color,1.0,1.0)

func open_doors():
	for i in range(0,4):
		if neighbours[i] != null:
			if neighbours[i].is_in_group("room"):
				if i == 0:
					$door_up/collision.set_deferred("disabled", true)
				if i == 1:
					$door_right/collision.set_deferred("disabled", true)
				if i == 2:
					$door_down/collision.set_deferred("disabled",true)
				if i == 3:
					$door_left/collision.set_deferred("disabled",true)


func _on_room_area_body_entered(body):
	if body.is_in_group("character"):
		body.grid_pos = grid_pos
