extends Node3D

@onready var viewblocker_parent: Control = $"Camera/dialogue UI/viewblocker parent"

func _ready() -> void:
	viewblocker_parent.show()
