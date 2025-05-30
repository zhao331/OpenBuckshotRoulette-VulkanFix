class_name OptionsManager extends Node

@export var controller : ControllerManager

@export var defaultOption_language : String = "ZHS"
@export var defaultOption_windowed : bool
@export var defaultOption_controllerActive : bool
var defaultOption_inputmap_keyboard = {
	"ui_accept": InputMap.action_get_events("ui_accept")[0],
	"ui_cancel": InputMap.action_get_events("ui_cancel")[0],
	"ui_left": InputMap.action_get_events("ui_left")[0],
	"ui_right": InputMap.action_get_events("ui_right")[0],
	"ui_up": InputMap.action_get_events("ui_up")[0],
	"ui_down": InputMap.action_get_events("ui_down")[0],
	"reset": InputMap.action_get_events("reset")[0],
	"exit game": InputMap.action_get_events("exit game")[0],
	"free look toggle": InputMap.action_get_events("free look toggle")[0],
}
var defaultOption_inputmap_controller = {
	"ui_accept": InputMap.action_get_events("ui_accept")[1],
	"ui_cancel": InputMap.action_get_events("ui_cancel")[1],
	"ui_left": InputMap.action_get_events("ui_left")[1],
	"ui_right": InputMap.action_get_events("ui_right")[1],
	"ui_up": InputMap.action_get_events("ui_up")[1],
	"ui_down": InputMap.action_get_events("ui_down")[1],
	"reset": InputMap.action_get_events("reset")[1],
	"exit game": InputMap.action_get_events("exit game")[1],
	"free look toggle": InputMap.action_get_events("free look toggle")[1],
}

@export var ui_windowed : CanvasItem
@export var ui_fullscreen : CanvasItem
@export var ui_deviceController : CanvasItem
@export var ui_deviceMouse : CanvasItem
@export var button_windowed : ButtonClass
@export var button_fullscreen : ButtonClass
@export var menu : MenuManager
@export var ui_volume : Label
@export var checkmark_colorblind : Checkmark
@export var checkmark_greyscale : Checkmark

const savePath := "user://buckshotroulette_options_12.shell"
var data = {}
var data_inputmap = {}
var setting_inputmap_keyboard = {}
var setting_inputmap_controller = {}
var setting_volume = 1
var setting_windowed = false
var setting_language = "EN"
var setting_controllerEnabled = false
var setting_colorblind = false
var setting_greyscale_death = true
var setting_music_enabled = true

func _ready():
	OpenBRGlobal.options_manager = self
	LoadSettings()
	if (!receivedFile):
		setting_windowed = defaultOption_windowed
		setting_controllerEnabled = defaultOption_controllerActive
		setting_language = defaultOption_language
		setting_inputmap_keyboard = defaultOption_inputmap_keyboard
		setting_inputmap_controller = defaultOption_inputmap_controller
		#ApplySettings_window()
		ApplySettings_controller()
		ApplySettings_language()
		ApplySettings_inputmap()
		ApplySettings_greyscaledeath()

func Printout():
	print("user current version: ", GlobalVariables.currentVersion)
	print("user current  hotfix: ", GlobalVariables.currentVersion_hotfix)

func Adjust(alias : String):
	match(alias):
		"increase":
			if setting_volume != 1:
				setting_volume = setting_volume + 0.05
				if setting_volume > 1:
					setting_volume = 1
			UpdateDisplay()
			ApplySettings_volume()
		"decrease":
			if setting_volume != 0:
				setting_volume = setting_volume - 0.05
			if setting_volume < 0:
				setting_volume = 0
			UpdateDisplay()
			ApplySettings_volume()
		"controller enable":
			setting_controllerEnabled = true
			ApplySettings_controller()
		"controller disable":
			setting_controllerEnabled = false
			ApplySettings_controller()
		"windowed":
			setting_windowed = true
			ApplySettings_window()
		"fullscreen":
			setting_windowed = false
			ApplySettings_window()
		
	if (alias != "increase" && alias != "decrease"): menu.ResetButtons()

func ToggleColorblind():
	setting_colorblind = !setting_colorblind
	checkmark_colorblind.UpdateCheckmark(setting_colorblind)
	ApplySettings_colorblind()

func ToggleGreyscaleDeath():
	setting_greyscale_death = !setting_greyscale_death
	checkmark_greyscale.UpdateCheckmark(setting_greyscale_death)
	ApplySettings_greyscaledeath()

func AdjustLanguage(alias : String):
	setting_language = alias
	ApplySettings_language()
	menu.ResetButtons()

func ApplySettings_volume():
	AudioServer.set_bus_volume_db(0, linear_to_db(setting_volume))
	UpdateDisplay()
	pass

func AdjustSettings_music():
	setting_music_enabled = !setting_music_enabled
	ApplySettings_music()

@export var anim_vinyl : AnimationPlayer
func ApplySettings_music():
	if (setting_music_enabled): anim_vinyl.speed_scale = 1
	else: anim_vinyl.speed_scale = 0
	AudioServer.set_bus_mute(1, !setting_music_enabled) #music
	AudioServer.set_bus_mute(2, !setting_music_enabled) #music secondary
	AudioServer.set_bus_mute(4, !setting_music_enabled) #music resolve
	AudioServer.get_property_list()
	GlobalVariables.music_enabled = setting_music_enabled

func UpdateDisplay():
	ui_volume.text = str(snapped(setting_volume * 100, .01)) + "%"

func ApplySettings_window(is_windowed = setting_windowed):
	if OpenBRGlobal.is_android(): return
	OpenBRGlobal.is_fullscreen = !is_windowed
	if (!is_windowed): 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		ui_fullscreen.modulate.a = 1
		ui_windowed.modulate.a = .5
		button_fullscreen.mainActive = true
		button_windowed.mainActive = true
	else: 
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		ui_fullscreen.modulate.a = .5
		ui_windowed.modulate.a = 1
		button_fullscreen.mainActive = true
		button_windowed.mainActive = true
	pass

func ApplySettings_controller():
	if (setting_controllerEnabled):
		controller.SetMainControllerState(true)
		ui_deviceController.modulate.a = 1
		ui_deviceMouse.modulate.a = .5
		GlobalVariables.controllerEnabled = true
	else:
		controller.SetMainControllerState(false)
		ui_deviceController.modulate.a = .5
		ui_deviceMouse.modulate.a = 1
		GlobalVariables.controllerEnabled = false

func ParseInputMapDictionary():
	setting_inputmap_keyboard = {
		"ui_accept": var_to_str(InputMap.action_get_events("ui_accept")[0]),
		"ui_cancel": var_to_str(InputMap.action_get_events("ui_cancel")[0]),
		"ui_left": var_to_str(InputMap.action_get_events("ui_left")[0]),
		"ui_right": var_to_str(InputMap.action_get_events("ui_right")[0]),
		"ui_up": var_to_str(InputMap.action_get_events("ui_up")[0]),
		"ui_down": var_to_str(InputMap.action_get_events("ui_down")[0]),
		"reset": var_to_str(InputMap.action_get_events("reset")[0]),
		"exit game": var_to_str(InputMap.action_get_events("exit game")[0]),
		"free look toggle": var_to_str(InputMap.action_get_events("free look toggle")[0])
	}
	setting_inputmap_controller = {
		"ui_accept": var_to_str(InputMap.action_get_events("ui_accept")[1]),
		"ui_cancel": var_to_str(InputMap.action_get_events("ui_cancel")[1]),
		"ui_left": var_to_str(InputMap.action_get_events("ui_left")[1]),
		"ui_right": var_to_str(InputMap.action_get_events("ui_right")[1]),
		"ui_up": var_to_str(InputMap.action_get_events("ui_up")[1]),
		"ui_down": var_to_str(InputMap.action_get_events("ui_down")[1]),
		"reset": var_to_str(InputMap.action_get_events("reset")[1]),
		"exit game": var_to_str(InputMap.action_get_events("exit game")[1]),
		"free look toggle": var_to_str(InputMap.action_get_events("free look toggle")[1])
	}

func ResetControls():
	setting_inputmap_keyboard = defaultOption_inputmap_keyboard
	setting_inputmap_controller = defaultOption_inputmap_controller
	ApplySettings_inputmap()
	keyrebinding.UpdateBindList()

@export var keyrebinding : Rebinding
var setting = false
func ApplySettings_inputmap():
	for key in setting_inputmap_keyboard:
		var value = setting_inputmap_keyboard[key]
		if (setting): value = str_to_var(value)
		InputMap.action_erase_events(key)
		InputMap.action_add_event(key, value)
	for key in setting_inputmap_controller:
		var value = setting_inputmap_controller[key]
		if (setting): value = str_to_var(value)
		InputMap.action_add_event(key, value)
	keyrebinding.UpdateBindList()
	setting = false

func ApplySettings_language():
	TranslationServer.set_locale(setting_language)

func ApplySettings_colorblind():
	GlobalVariables.colorblind = setting_colorblind

func ApplySettings_greyscaledeath():
	GlobalVariables.greyscale_death = setting_greyscale_death
	checkmark_greyscale.UpdateCheckmark(GlobalVariables.greyscale_death)

func SaveSettings():
	data = {
		#"has_read_introduction": roundManager.playerData.hasReadIntroduction,
		"setting_volume": setting_volume,
		"setting_windowed": setting_windowed,
		"setting_language" : setting_language,
		"setting_controllerEnabled" : setting_controllerEnabled,
		"setting_inputmap_keyboard": setting_inputmap_keyboard,
		"setting_inputmap_controller": setting_inputmap_controller,
		"setting_colorblind": setting_colorblind,
		"setting_music_enabled": setting_music_enabled,
		"setting_greyscale_death": setting_greyscale_death,
	}
	print("attempting to save settings")
	var file = FileAccess.open(savePath, FileAccess.WRITE)
	file.store_var(data)
	file.close()
	print("file closed")

var receivedFile = false
func LoadSettings():
	if (FileAccess.file_exists(savePath)):
		print("settings file found, attempting to load settings: ")
		print("")
		var file = FileAccess.open(savePath, FileAccess.READ)
		data = file.get_var()
		setting_volume = data.setting_volume
		setting_windowed = data.setting_windowed
		setting_language = data.setting_language
		setting_controllerEnabled = data.setting_controllerEnabled
		setting_inputmap_keyboard = data.setting_inputmap_keyboard
		setting_inputmap_controller = data.setting_inputmap_controller
		if (data.has('setting_colorblind')): 
			setting_colorblind = data.setting_colorblind
			if (checkmark_colorblind != null): checkmark_colorblind.UpdateCheckmark(setting_colorblind)
		if (data.has('setting_music_enabled')):
			setting_music_enabled = data.setting_music_enabled
		if (data.has('setting_greyscale_death')):
			setting_greyscale_death = data.setting_greyscale_death
			if (checkmark_greyscale != null): checkmark_greyscale.UpdateCheckmark(setting_greyscale_death)
		file.close()
		print("---------------------------------")
		print("user settings: ", data)
		print("---------------------------------")
		print("settings file closed")
		setting = true
		ApplySettings_music()
		ApplySettings_volume()
		ApplySettings_window()
		ApplySettings_language()
		ApplySettings_controller()
		ApplySettings_inputmap()
		ApplySettings_colorblind()
		ApplySettings_greyscaledeath()
		receivedFile = true
	else: print("user does not have settings file")
