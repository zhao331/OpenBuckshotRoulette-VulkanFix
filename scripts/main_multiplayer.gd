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
@onready var omni_light_3d_4_ls: OmniLight3D = $"light parent/OmniLight3D4 LS"
@onready var press_any_key_to_exit: Label = $"Camera/dialogue UI/press any key to exit"
@onready var mesh_instance_3d_bridge: MeshInstance3D = $"backroom main parent/Cube_120_CLUB/MeshInstance3D_Bridge"

@onready var invisible_nodes:= [
	signature_machine_main_parent,
	health_ui_dealer_side,
	health_ui_player_side,
	$"light parent/LightsAndroid",
	$"restroom_CLUB/bathroom wall main_crt hole/crt main parent/crt screen main/crt main icons/crt icon_top leaderboard",
	$"restroom_CLUB/bathroom wall main_crt hole/crt main parent/crt screen main/crt main icons/crt icon_global overview",
	$"restroom_CLUB/bathroom wall main_crt hole/crt main parent/crt screen main/crt main icons/crt icon_friends",
	$"player vehicle parent/vehicle/car door1/MeshInstance3D_EndingFinish",
	mesh_instance_3d_bridge,
	$"Camera/post processing/ColorRect_VeryLowPerfShader",
	$OmniLight3D_Extra,
	$"Camera/dialogue UI/viewblocker parent"
]
@onready var invisible_nodes_android:= [
]
@onready var invisible_nodes_low_perf:= [
]
@onready var invisible_nodes_very_low_perf:= [
]

@onready var light_main_door_2_club_ls: OmniLight3D = $"backroom main parent/light main door2_CLUB LS"
@onready var env_filter: Control = $"Camera/post processing/posterization test"
@onready var camera: MouseRaycast = $Camera
@onready var timer_refresh_fov: Timer = $Camera/Timer_RefreshFov
@onready var collision_shape_3d: CollisionShape3D = $"intro parent/backroom door/StaticBody3D/CollisionShape3D"
@onready var collision_shape_3d_backroom_door: CollisionShape3D = $"intro parent/backroom door/StaticBody3D/CollisionShape3D"
@onready var omni_light_3d_bathroom: OmniLight3D = $"backroom main parent/light main door3 LS"
@onready var omni_light_3d_active: OmniLight3D = $"light parent/lght_backroom main2"
@onready var color_rect_very_low_perf_shader: ColorRect = $"Camera/post processing/ColorRect_VeryLowPerfShader"
@onready var animator_intro: AnimationPlayer = $"intro parent/animator_intro"
@onready var match_fixing: MeshInstance3D = $"restroom_CLUB/bathroom wall main_crt hole/MeshInstance3D_MatchFixing"
@onready var label_3d_gambling_manipulated: Label3D = $"tabletop parent/main tabletop/health counter/health counter ui parent/round indicator parent/Label3D_GamblingManipulated"
@onready var cursor_manager: CursorManager = $"standalone managers/cursor manager"

func _ready() -> void:
	OpenBRGlobal.main = self
	OpenBRGlobal.is_multiplayer = true
	TranslationServer.set_locale('ZHS')
	init_invisible_nodes()
	refresh_collision_shape()
	animator_intro.play("camera idle bathroom")
	cursor_manager.SetCursor(true, false)

func init_invisible_nodes():
	for node in invisible_nodes:
		if node != null: node.hide()
	if OpenBRGlobal.is_android():
		light_main_door_3_ls.shadow_enabled = false
		club_light_underside_club_us.shadow_enabled = false
		omni_light_3d_4_ls.shadow_enabled = false
		$"backroom main parent/OmniLight3D_ClubTop".shadow_enabled = false
		omni_light_3d_active.shadow_enabled = false
		
		$"light parent/LightsAndroid".show()
		
		for node in invisible_nodes_android:
			if node != null: node.hide()
		cube_120_club.mesh.surface_get_material(3).shading_mode = StandardMaterial3D.SHADING_MODE_PER_VERTEX
		cube_120_club.mesh.surface_get_material(3).specular_mode = StandardMaterial3D.SPECULAR_DISABLED
	
	if OpenBRConfig.fetch('visual', 'env_filter', true) == false: env_filter.hide()
	if OpenBRConfig.fetch('visual', 'low_perf_mode', false) and OpenBRGlobal.is_android():
		for node in invisible_nodes_low_perf:
			if node != null: node.hide()
		if OpenBRConfig.fetch('visual', 'very_low_perf_mode', false):
			pass
	if OpenBRGlobal.WATCH_ONLY:
		for node in invisible_nodes_very_low_perf:
			if node != null: node.hide()
		$OmniLight3D_Extra.show()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_BACK and event.is_pressed():
		print('Back')

func refresh_collision_shape():
	var vec:= get_window().size
	if (float(vec.x) / vec.y) < 1.32:
		collision_shape_3d_backroom_door.scale.z = 2.5
