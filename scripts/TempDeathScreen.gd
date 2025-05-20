class_name TempDeathScreen extends Node

@export var isDeathScreen : bool
@export var savefile : SaveFileManager
@export var viewblocker : ColorRect
@export var speaker : AudioStreamPlayer2D
var allowed = true
var fs = false

func _ready():
	# if (isDeathScreen):
	# 	print("changing scene to: main")
	# 	SceneChanger.change("res://scenes/main.tscn")
	pass

#func _unhandled_input(event):
#	if (event.is_action_pressed("enter") && allowed && !fs):
#		viewblocker.color = Color(0, 0, 0, 1)
#		speaker.pitch_scale = .8
#		await get_tree().create_timer(.5, false).timeout
#		if (!isDeathScreen):
#			savefile.ClearSave()
#		SceneChanger.change("res://scenes/main.tscn")
#		allowed = false
