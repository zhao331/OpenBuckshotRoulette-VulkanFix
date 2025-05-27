extends Control
@onready var label_fps: Label = $Label_FPS

const PATH_PROJ_SETTINGS:= 'user://project_settings.ini'
const WATCH_ONLY:= false

var options_manager: OptionsManager
var round_manager: RoundManager
var ending_manager: EndingManager
var main
var menu

var is_fullscreen:= true
var frames:= 0
var fps:= 7
var is_multiplayer:= false

var _is_mobile_renderer:= false

func _ready() -> void:
	print('User data dir: ' + OS.get_user_data_dir())
	if ProjectSettings.get_setting("rendering/renderer/rendering_method") == 'mobile': _is_mobile_renderer = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_max_fps(-1)
	#scale_viewport_to_screen()

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
	
	if Input.is_action_pressed('OpenBR_faster'):
		Engine.time_scale = 4
	elif Input.is_action_pressed('OpenBR_slower'):
		Engine.time_scale = 0.4
	else:
		Engine.time_scale = 1

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
	fps = frames
	label_fps.text = 'FPS: ' + str(frames)
	frames = 0
	pass # Replace with function body.

func set_max_fps(fps:int = 60):
	if fps == -1: fps = OpenBRConfig.fetch('visual', 'max_fps', 0)
	else: OpenBRConfig.put('visual', 'max_fps', fps)
	print('Set max fps: ', fps)
	Engine.max_fps = fps

func action(act:String):
	print('Action: ', act)
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
		'low_perf_mode_on':
			OpenBRConfig.put('visual', 'low_perf_mode', true)
		'low_perf_mode_off':
			OpenBRConfig.put('visual', 'low_perf_mode', false)
		'very_low_perf_mode_on':
			if menu:
				menu.shell_waterfall_1.hide()
				menu.shell_waterfall_2.hide()
			OpenBRConfig.put('visual', 'very_low_perf_mode', true)
		'very_low_perf_mode_off':
			if menu:
				menu.shell_waterfall_1.show()
				menu.shell_waterfall_2.show()
			OpenBRConfig.put('visual', 'very_low_perf_mode', false)
		'match_fixing_close':
			main.animator_intro.play_backwards('camera check match fixing')
			main.match_fixing.control.hide()
			await main.animator_intro.animation_finished
			if main.animator_intro.assigned_animation == 'camera check match fixing': main.animator_intro.play('camera idle bathroom')
			main.match_fixing.focused = false
		'multiplayer':
			OS.alert('多人游戏的实现十分复杂(尤其是从SteamAPI移植到普通的网络通信)，1503Dev暂时没有能力去修复多人游戏\n\n如有疑问，反馈和开发日志在Github', '为什么此选项不可用？')
			#OS.alert('在线多人游戏的实现十分复杂(尤其是从SteamAPI移植到普通的网络通信)，1503Dev暂时没有能力去修复在线多人游戏\n\n如需要继续进入离线多人游戏(玩家vs人机)，请关闭警告', '为什么此选项被标记为不可用？')
			#SceneChanger.change('res://multiplayer/scenes/mp_lobby.tscn')

func interact_with(alias:String):
	if alias == 'ending_finish':
		if ending_manager != null:
			if (ending_manager.waitingForInput): 
				ending_manager.ExitGame()
				ending_manager.waitingForInput = false
	else:
		if main != null: main.interact_with(alias)
		print('Interact: ', alias)
		match alias:
			'pill choice yes':
				if main != null:
					await sleep(2.4)
					main.omni_light_3d_bathroom.hide()
					main.omni_light_3d_bathroom.show()
			'camera check match fixing':
				if main.match_fixing.focused: return
				main.animator_intro.play('camera check match fixing')
				await main.animator_intro.animation_finished
				main.match_fixing.control.show()
			'bathroom door':
				if OpenBRGlobal.is_multiplayer: return
				main.load_gambling()

func get_formatted_time() -> String:
	var time_dict = Time.get_time_dict_from_system()
	return "%02d:%02d:%02d" % [
		time_dict["hour"], 
		time_dict["minute"], 
		time_dict["second"]
	]

func sleep(sec:float):
	await get_tree().create_timer(sec).timeout

func get_touch_delay() -> float:
	var delay:= 1 - float(fps) * 0.04
	if delay < 0.07: delay = 0.07
	return delay
