extends Node

var rng = RandomNumberGenerator.new()
var scale_factor = 4

func _ready():
	var screen_size = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height"))
	ProjectSettings.set_setting("display/window/size/viewport_width",screen_size.x * scale_factor)
	ProjectSettings.set_setting("display/window/size/viewport_height",screen_size.x * scale_factor)
	rng.seed = hash(rng.randi())
	print(rng.seed)
