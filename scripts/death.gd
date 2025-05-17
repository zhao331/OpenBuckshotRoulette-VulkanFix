extends Node3D

func _ready() -> void:
	print('dead')
	print(OpenBrGlobal.fetch_tree().change_scene_to_file("res://scenes/main.tscn"))
	print('dead / 2')


func _on_timer_timeout() -> void:
	print(OpenBrGlobal.fetch_tree().change_scene_to_file("res://scenes/main.tscn"))
	pass # Replace with function body.
