class_name Clickable extends Control
@onready var texture_rect: TextureRect = $TextureRect

@export var action:String
@export var cursor : CursorManager

func _ready() -> void:
	texture_rect.hide()

func _on_button_pressed() -> void:
	print('Action: ', action)
	OpenBRGlobal.action(action)
	pass # Replace with function body.


func _on_button_mouse_entered() -> void:
	cursor.SetCursorImage("hover")
	pass # Replace with function body.


func _on_button_mouse_exited() -> void:
	cursor.SetCursorImage("point")
	pass # Replace with function body.
