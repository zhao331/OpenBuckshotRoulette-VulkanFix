extends Node

var options_manager: OptionsManager

var is_fullscreen:= true

var _is_mobile_renderer:= false

func _ready() -> void:
	print('User data dir: ' + OS.get_user_data_dir())
	if ProjectSettings.get_setting("rendering/renderer/rendering_method") == 'mobile': _is_mobile_renderer = true
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

func is_android() -> bool:
	#return true
	if OS.get_name() == 'Android': return true
	return false

func fetch_tree() -> SceneTree:
	return get_tree()

func is_mobile_renderer() -> bool:
	return _is_mobile_renderer
