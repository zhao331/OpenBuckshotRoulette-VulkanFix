extends Node

var options_manager: OptionsManager

var is_fullscreen:= true

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('fullscreen'):
		if options_manager != null: options_manager.ApplySettings_window(is_fullscreen)
		else:
			is_fullscreen = !is_fullscreen
			if is_fullscreen: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif Input.is_action_just_pressed('OpenBR_test'):
		get_window()
