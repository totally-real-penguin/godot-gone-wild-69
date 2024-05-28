extends CharacterBody2D

var grid_pos := Vector2i(0,0)
var speed = 200

func _physics_process(delta):
	var input_vector := Vector2()
	input_vector.x = Input.get_action_raw_strength("ui_right") - Input.get_action_raw_strength("ui_left")
	input_vector.y = Input.get_action_raw_strength("ui_down") - Input.get_action_raw_strength("ui_up")
	velocity = input_vector * speed
	move_and_slide()
