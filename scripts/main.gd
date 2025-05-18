extends Node3D

@onready var viewblocker_parent: Control = $"Camera/dialogue UI/viewblocker parent"
@onready var signature_machine_main_parent: Node3D = $"signature machine2/signature machine main parent"
@onready var health_ui_dealer_side: Node3D = $"tabletop parent/main tabletop/health counter/health counter ui parent/health UI_dealer side"
@onready var health_ui_player_side: Node3D = $"tabletop parent/main tabletop/health counter/health counter ui parent/health UI_player side"
@onready var cube_120_club: MeshInstance3D = $"backroom main parent/Cube_120_CLUB"
@onready var paperwork_4_001: MeshInstance3D = $"backroom visual parent/paperwork4_001"
@onready var paperwork_4_002: MeshInstance3D = $"backroom visual parent/paperwork4_002"
@onready var paperwork_4_003: MeshInstance3D = $"backroom visual parent/paperwork4_003"
@onready var paperwork_4_009: MeshInstance3D = $"backroom visual parent/paperwork4_009"
@onready var light_main_door_3_ls: OmniLight3D = $"backroom main parent/light main door3 LS"
@onready var club_light_underside_club_us: OmniLight3D = $"backroom main parent/club light underside_CLUB US"
@onready var lght_backroom_main_ls: OmniLight3D = $"light parent/lght_backroom main LS"
@onready var omni_light_3d_4_ls: OmniLight3D = $"light parent/OmniLight3D4 LS"
@onready var press_any_key_to_exit: Label = $"Camera/dialogue UI/press any key to exit"

@onready var light_main_door_2_club_ls: OmniLight3D = $"backroom main parent/light main door2_CLUB LS"

@onready var invisible_nodes:= [
	signature_machine_main_parent,
	health_ui_dealer_side,
	health_ui_player_side,
	$"light parent/lights_low_power",
	$"restroom_CLUB/bathroom wall main_crt hole/crt main parent/crt screen main/crt main icons/crt icon_top leaderboard",
	$"restroom_CLUB/bathroom wall main_crt hole/crt main parent/crt screen main/crt main icons/crt icon_global overview",
	$"restroom_CLUB/bathroom wall main_crt hole/crt main parent/crt screen main/crt main icons/crt icon_friends",
	$"player vehicle parent/vehicle/car door1/MeshInstance3D_EndingFinish"
]
@onready var invisible_nodes_android:= [
	paperwork_4_001,
	paperwork_4_002,
	paperwork_4_003,
	paperwork_4_009,
	light_main_door_2_club_ls,
	$"backroom upper cables1",
	$"backroom visual parent/Cube_073",
	$"backroom visual parent/Plane_023",
	$"backroom visual parent/circuitboards_017",
	$"backroom visual parent/circuitboards_007",
	$"light parent/OmniLight3D LS",
	$"light parent/OmniLight3D2 LS",
	$"light parent/OmniLight3D6 LS",
	$"light parent/OmniLight3D3 LS",
	$"light parent/light_barrel mask LS",
	$"light parent/light_tabletop interior LS",
	$"light parent/OmniLight3D5 LS",
	$"light parent/lght_backroom main LS",
	$"light parent/OmniLight3D4 LS",
	$"backroom visual parent/Cube_006",
	$restroom_CLUB/Cube_116,
	$"backroom main parent/Cube_120_CLUB/Cube_107",
	$"backroom visual parent/Cube_001/Cylinder_002",
	$"backroom visual parent/Cube_043/Cylinder_001",
	$"backroom visual parent/Plane_024",
	$"backroom visual parent/Cylinder_032",
	$"backroom visual parent/Cylinder_003",
	$"backroom visual parent/Cube_072",
	$"backroom visual parent/ash tray",
	$"backroom visual parent/magazine2",
	$"backroom visual parent/magazine1"
]

func _ready() -> void:
	#if OpenBRGlobal.is_android():
		#press_any_key_to_exit.text = tr('TOUCH_SCREEN_EXIT')
	#print('main')
	#TranslationServer.set_locale('ZHS')
	init_invisible_nodes()
	viewblocker_parent.show()

func init_invisible_nodes():
	for node:Node3D in invisible_nodes:
		node.hide()
	if OpenBRGlobal.is_android():
		light_main_door_3_ls.shadow_enabled = false
		club_light_underside_club_us.shadow_enabled = false
		lght_backroom_main_ls.shadow_enabled = false
		omni_light_3d_4_ls.shadow_enabled = false
		$"light parent/lights_low_power".show()
		for node in invisible_nodes_android:
			node.hide()
		cube_120_club.mesh.surface_get_material(3).shading_mode = StandardMaterial3D.SHADING_MODE_PER_VERTEX
		cube_120_club.mesh.surface_get_material(3).specular_mode = StandardMaterial3D.SPECULAR_DISABLED
