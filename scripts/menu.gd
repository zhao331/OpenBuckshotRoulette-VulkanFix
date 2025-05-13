extends Node3D
@onready var bracket_selection_windowed: TextureRect = $"Camera/dialogue UI/menu ui/options_audio video/bracket selection_windowed"
@onready var bracket_selection_fullscreen: TextureRect = $"Camera/dialogue UI/menu ui/options_audio video/bracket selection_fullscreen"
@onready var option_monitor_fullscreen: TextureRect = $"Camera/dialogue UI/menu ui/options_audio video/option monitor_fullscreen"
@onready var option_monitor_windowed: TextureRect = $"Camera/dialogue UI/menu ui/options_audio video/option monitor_windowed"
@onready var true_button_controller: Button = $"Camera/dialogue UI/menu ui/sub options select/true button_controller"
@onready var button_controller: Label = $"Camera/dialogue UI/menu ui/sub options select/button_controller"
@onready var viewblocker_parent: Control = $"Camera/dialogue UI/viewblocker parent"

func _ready() -> void:
	viewblocker_parent.show()
	if OpenBrGlobal.is_android():
		bracket_selection_fullscreen.hide()
		bracket_selection_windowed.hide()
		option_monitor_fullscreen.hide()
		option_monitor_windowed.hide()
		true_button_controller.hide()
		button_controller.label_settings.font_color = Color.from_string('#5d5d5d', Color.WHITE)
