extends Node3D

@onready var env_filter: Control = $"Camera/post processing/opengl post processing"

func _ready() -> void:
	if OpenBRConfig.fetch('visual', 'env_filter', true) == false: env_filter.hide()
