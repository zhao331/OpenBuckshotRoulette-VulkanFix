extends Control
@onready var label_fps: Label = $Label_FPS

var options_manager: OptionsManager
var round_manager: RoundManager

var is_fullscreen:= true
var frames:= 0

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
	if Input.is_action_just_pressed('OpenBR_test'):
		get_window()
	
	if round_manager != null:
		if Input.is_action_just_pressed('OpenBR_add_health'):
			round_manager.health_player += 1
			print('My health: ', round_manager.health_player)
		if Input.is_action_just_pressed('OpenBR_subtract_health'):
			round_manager.health_player -= 1
			print('My health: ', round_manager.health_player)
		if Input.is_action_just_pressed('OpenBR_add_dealer_health'):
			round_manager.health_opponent += 1
			print('Opponent health: ', round_manager.health_opponent)
		if Input.is_action_just_pressed('OpenBR_substract_dealer_health'):
			round_manager.health_opponent -= 1
			print('Opponent health: ', round_manager.health_opponent)

func is_android() -> bool:
	#return true
	if OS.get_name() == 'Android': return true
	return false

func fetch_tree() -> SceneTree:
	return get_tree()

func is_mobile_renderer() -> bool:
	return _is_mobile_renderer

func uri(uri:String):
	OS.shell_open(uri)
func _process(delta: float) -> void:
	frames += 1

func _on_timer_fps_timeout() -> void:
	label_fps.text = 'FPS: ' + str(frames)
	frames = 0
	pass # Replace with function body.
