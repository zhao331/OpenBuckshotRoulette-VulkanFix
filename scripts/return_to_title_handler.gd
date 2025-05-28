extends Node

func _ready() -> void:
	$"..".hide()

func action(act:String):
	match act:
		'return_to_title':
			SceneChanger.change('res://scenes/menu.tscn')
		'return_to_title_hide':
			$"..".hide()

func _input(event: InputEvent) -> void:
	if (event is InputEventKey and event.keycode == KEY_BACK and event.is_pressed()) or Input.is_action_just_pressed('debug_back'):
		$"..".visible = !$"..".visible
