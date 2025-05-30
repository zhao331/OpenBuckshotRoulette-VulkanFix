extends Node3D

func _ready() -> void:
	SceneChanger.change('res://scenes/main.tscn')


func _on_timer_timeout() -> void:
	SceneChanger.change('res://scenes/main.tscn')
	pass # Replace with function body.
