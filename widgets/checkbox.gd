class_name Checkbox extends Clickable

@onready var texture_rect_icon: TextureRect = $TextureRect_Icon

@export var checked:bool = false
@export var check_action:String = ''
@export var uncheck_action:String = ''

func _ready() -> void:
	super._ready()	
	refresh_icon()

func refresh_icon():
	if checked: texture_rect_icon.texture = load('res://misc/checkmark_active2.png')
	else: texture_rect_icon.texture = load('res://misc/checkmark_inactive.png')

func _on_button_pressed():
	super._on_button_pressed()
	checked = !checked
	refresh_icon()
	if checked && !check_action.is_empty(): 
		if handler != null: handler.action(check_action)
		else: OpenBRGlobal.action(check_action)
	elif !checked && !uncheck_action.is_empty():
		if handler != null: handler.action(uncheck_action)
		else: OpenBRGlobal.action(uncheck_action)

func set_checked(_checked:bool):
	checked = _checked
	refresh_icon()
