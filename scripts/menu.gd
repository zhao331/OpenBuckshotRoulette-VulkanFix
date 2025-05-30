extends Node3D
@onready var bracket_selection_windowed: TextureRect = $"Camera/dialogue UI/menu ui/options_audio video/bracket selection_windowed"
@onready var bracket_selection_fullscreen: TextureRect = $"Camera/dialogue UI/menu ui/options_audio video/bracket selection_fullscreen"
@onready var option_monitor_fullscreen: TextureRect = $"Camera/dialogue UI/menu ui/options_audio video/option monitor_fullscreen"
@onready var option_monitor_windowed: TextureRect = $"Camera/dialogue UI/menu ui/options_audio video/option monitor_windowed"
@onready var true_button_controller: Button = $"Camera/dialogue UI/menu ui/sub options select/true button_controller"
@onready var button_controller: Label = $"Camera/dialogue UI/menu ui/sub options select/button_controller"
@onready var viewblocker_parent: Control = $"Camera/dialogue UI/viewblocker parent"

@onready var invisible_nodes_android:= [
	bracket_selection_fullscreen,
	bracket_selection_windowed,
	option_monitor_fullscreen,
	option_monitor_windowed,
	true_button_controller,
	$"Camera/dialogue UI/menu ui/options_audio video/true button_fullscreen",
	$"Camera/dialogue UI/menu ui/options_audio video/true button_windowed"
]

@onready var checkbox_env_filter: Checkbox = $"Camera/dialogue UI/menu ui/options_audio video/Checkbox_EnvFilter"
@onready var checkbox_low_perf_mode: Checkbox = $"Camera/dialogue UI/menu ui/options_audio video/Control_Android/Checkbox_LowPerfMode"
@onready var control_android: Control = $"Camera/dialogue UI/menu ui/options_audio video/Control_Android"
@onready var checkbox_very_low_perf_mode: Checkbox = $"Camera/dialogue UI/menu ui/options_audio video/Control_Android/Checkbox_VeryLowPerfMode"
@onready var shell_waterfall_1: Node3D = $"shell waterfall2"
@onready var shell_waterfall_2: Node3D = $"shell waterfall4"
@onready var control_new_version: Control = $"Camera/dialogue UI/menu ui/Control_NewVersion"
@onready var label_new_version_version: Label = $"Camera/dialogue UI/menu ui/Control_NewVersion/Label_Version"
@onready var label_check_update: Label = $"Camera/dialogue UI/menu ui/main screen/Label_CheckUpdate"
@onready var http_request_check_update: HTTPRequest = $"Camera/dialogue UI/menu ui/main screen/Label_CheckUpdate/HTTPRequest_CheckUpdate"

var update_url:= ''

func _ready() -> void:
	OpenBRGlobal.menu = self
	viewblocker_parent.show()
	init_invisible_nodes()
	if OpenBRGlobal.is_android():
		button_controller.label_settings.font_color = Color.from_string('#5d5d5d', Color.WHITE)
		control_android.show()
	else:
		control_android.hide()
	
	if OpenBRConfig.fetch('visual', 'env_filter', true) == false: checkbox_env_filter.set_checked(false)
	if OpenBRConfig.fetch('visual', 'low_perf_mode', false): checkbox_low_perf_mode.set_checked(true)
	if OpenBRConfig.fetch('visual', 'very_low_perf_mode', false):
		checkbox_very_low_perf_mode.set_checked(true)
		shell_waterfall_1.hide()
		shell_waterfall_2.hide()

func _on_true_button_github_pressed() -> void:
	OpenBRGlobal.uri(GlobalVariables.github_link)
	pass # Replace with function body.

func init_invisible_nodes():
	label_check_update.hide()
	if OpenBRGlobal.is_android():
		label_check_update.show()
		for node in invisible_nodes_android:
			node.hide()
	control_new_version.hide()

func action(act:String):
	match act:
		'check_update':
			label_check_update.get_child(0).action = ''
			label_check_update.modulate.a = float(56) / 255
			http_request_check_update.request('https://openbr.1503dev.top/version.json')
		'update_cancel':
			control_new_version.hide()
		'update':
			OS.shell_open(update_url)


func _on_http_request_check_update_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	label_check_update.get_child(0).action = 'check_update'
	label_check_update.modulate.a = float(143) / 255
	if response_code >= 200 and response_code < 300:
		var json:Dictionary = JSON.parse_string(body.get_string_from_utf8())
		if json.version_code > 9:
			label_new_version_version.text = json.version_name
			update_url = json.url
			control_new_version.show()
		else:
			OS.alert(tr('ALREADY_LATEST_VERSION'))
