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
	if OpenBRGlobal.is_android():
		for node in invisible_nodes_android:
			node.hide()
