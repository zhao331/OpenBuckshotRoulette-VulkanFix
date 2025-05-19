extends Control
@onready var label_fps: Label = $Label_FPS

var options_manager: OptionsManager
var round_manager: RoundManager
var ending_manager: EndingManager

var is_fullscreen:= true
var frames:= 0

var _is_mobile_renderer:= false

func _ready() -> void:
	print('User data dir: ' + OS.get_user_data_dir())
	if ProjectSettings.get_setting("rendering/renderer/rendering_method") == 'mobile': _is_mobile_renderer = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_max_fps(-1)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('fullscreen'):
		if options_manager != null: options_manager.ApplySettings_window(is_fullscreen)
		else:
			is_fullscreen = !is_fullscreen
			if is_fullscreen: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			else: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if Input.is_action_just_pressed('OpenBR_test'):
		#if round_manager != null:
			#print(round_manager.currentRound)
			#round_manager.currentRound = 2
		pass
	
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
	return true
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

func set_max_fps(fps:int = 60):
	if fps == -1: fps = OpenBRConfig.fetch('visual', 'max_fps', 0)
	else: OpenBRConfig.put('visual', 'max_fps', fps)
	print('Set max fps: ', fps)
	Engine.max_fps = fps

func action(act:String):
	match act:
		'max_fps_30':
			set_max_fps(30)
		'max_fps_60':
			set_max_fps(60)
		'max_fps_90':
			set_max_fps(90)
		'max_fps_120':
			set_max_fps(120)
		'max_fps_0':
			set_max_fps(0)
		'env_filter_on':
			OpenBRConfig.put('visual', 'env_filter', true)
		'env_filter_off':
			OpenBRConfig.put('visual', 'env_filter', false)

func interact_with(alias:String):
	if alias == 'ending_finish':
		if ending_manager != null:
			if (ending_manager.waitingForInput): 
				ending_manager.ExitGame()
				ending_manager.waitingForInput = false

func get_formatted_time() -> String:
	var time_dict = Time.get_time_dict_from_system()
	return "%02d:%02d:%02d" % [
		time_dict["hour"], 
		time_dict["minute"], 
		time_dict["second"]
	]
