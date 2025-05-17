extends Node3D

@onready var viewblocker_parent: Control = $"Camera/dialogue UI/viewblocker parent"
@onready var signature_machine_main_parent: Node3D = $"signature machine2/signature machine main parent"
@onready var health_ui_dealer_side: Node3D = $"tabletop parent/main tabletop/health counter/health counter ui parent/health UI_dealer side"
@onready var health_ui_player_side: Node3D = $"tabletop parent/main tabletop/health counter/health counter ui parent/health UI_player side"

@onready var light_main_door_2_club_ls: OmniLight3D = $"backroom main parent/light main door2_CLUB LS"

@onready var invisible_nodes:= [
	signature_machine_main_parent,
	health_ui_dealer_side,
	health_ui_player_side
]

func _ready() -> void:
	TranslationServer.set_locale('ZHS')
	init_invisible_nodes()
	viewblocker_parent.show()

func init_invisible_nodes():
	if OpenBrGlobal.is_android():
		light_main_door_2_club_ls.hide()
	for node in invisible_nodes:
		node.hide()
