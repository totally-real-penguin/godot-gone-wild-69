extends Node

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready():
	rng.seed = hash(rng.randi())
