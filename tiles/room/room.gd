extends Node2D

var grid_pos : Vector2i = Vector2i(0,0)
var distance : int = 0
var color : float
var neighbours : Array = [
	null, #up
	null, #right
	null, #down
	null] #left

func open_doors():
	for i in range(0,4):
		if neighbours[i] != null:
			if neighbours[i].is_in_group("room"):
				if i == 0:
					$door_up/collision.set_deferred("disabled", true)
					$door_up/door_sprite.visible = false
				if i == 1:
					$door_right/collision.set_deferred("disabled", true)
					$door_right/door_sprite.visible = false
				if i == 2:
					$door_down/collision.set_deferred("disabled",true)
					$door_down/door_sprite.visible = false
				if i == 3:
					$door_left/collision.set_deferred("disabled",true)
					$door_left/door_sprite.visible = false


func _on_room_area_body_entered(body):
	if body.is_in_group("character"):
		body.grid_pos = grid_pos
