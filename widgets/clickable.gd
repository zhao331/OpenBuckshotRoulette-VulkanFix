class_name Clickable extends Control
@onready var texture_rect: TextureRect = $TextureRect
@onready var audio_stream_player_2d_press: AudioStreamPlayer2D = $AudioStreamPlayer2D_Press
@onready var audio_stream_player_2d_hover: AudioStreamPlayer2D = $AudioStreamPlayer2D_Hover

@export var action:String = ''
@export var cursor : CursorManager

func _ready() -> void:
	texture_rect.hide()

func _on_button_pressed() -> void:
	print('On clickable pressed')
	audio_stream_player_2d_press.stop()
	audio_stream_player_2d_press.play()
	if action.is_empty(): return
	OpenBRGlobal.action(action)
	pass # Replace with function body.


func _on_button_mouse_entered() -> void:
	audio_stream_player_2d_hover.stop()
	audio_stream_player_2d_hover.play()
	cursor.SetCursorImage("hover")
	pass # Replace with function body.


func _on_button_mouse_exited() -> void:
	cursor.SetCursorImage("point")
	pass # Replace with function body.
