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
	$OmniLight3D_Extra
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
	$"backroom visual parent/magazine1",
	$"backroom visual parent/Cube_046",
	$"backroom visual parent/cup",
	$"backroom visual parent/Cylinder_006",
	$"backroom visual parent/circuitboards_001",
	$"backroom visual parent/cigarette butts"
]
@onready var invisible_nodes_low_perf:= [
	$"restroom_CLUB/faucet parent_normal",
	$restroom_CLUB/Cube_111/Cube_122,
	$"restroom_CLUB/Cube_111/faucet tap_normal2",
	$"restroom_CLUB/Cube_111/faucet tap_normal3",
	$"restroom_CLUB/Cube_111/faucet tap_normal",
	$restroom_CLUB/Cube_112,
	$"light parent/LightsAndroid/OmniLight3D_Android_Backroom1",
	$"light parent/LightsAndroid/OmniLight3D_Android_Backroom2",
	$"backroom visual parent/TCom_AudioEquipment0039_1_M_002",
	$"backroom visual parent/Cylinder_005",
	$"backroom visual parent/Cylinder_004",
	$"backroom visual parent/Cube_003",
	$"backroom visual parent/Cube_005",
	$"backroom visual parent/boombox",
	$"backroom visual parent/TCom_AudioEquipment0039_1_M_001",
	$"backroom main parent/Cube_120_CLUB/Cube_106",
	$"backroom main parent/Cube_120_CLUB/Cube_093",
	$"backroom main parent/club light underside_CLUB US",
	$restroom_CLUB/Cube_117,
	$"restroom_CLUB/bathroom wall main_crt hole/faucets_crt hole",
	$"backroom visual parent/Cube_047",
	$"backroom visual parent/Cube_001",
	$"backroom visual parent/Cube_043"
]
@onready var invisible_nodes_very_low_perf:= [
	$"backroom visual parent/TCom_AudioEquipment0064_S",
	$"backroom visual parent/TCom_AudioEquipment0039_1_M_004",
	$"backroom visual parent/TCom_AudioEquipment0039_1_M",
	$"backroom visual parent/TCom_AudioEquipment0068_S",
	$"backroom visual parent/BezierCurve_004",
	$"backroom visual parent/BezierCurve_001",
	$"backroom visual parent/BezierCurve_005",
	$"backroom visual parent/Cube_039",
	$"backroom visual parent/Cube_039",
	$"backroom visual parent/BezierCurve_001",
	$"backroom visual parent/Plane_024",
	$"restroom_CLUB/mirror normal",
	$"restroom_CLUB/bathroom wall main_crt hole/mirror broken",
	$"backroom visual parent/BezierCurve_002",
	$"backroom visual parent/Cube",
	$"backroom visual parent/Cube_002",
	$"backroom visual parent/BezierCurve_006",
	$"backroom visual parent/BezierCurve_003",
	$"backroom main parent/Cube_120_CLUB/Empty_002",
	$"restroom_CLUB/trig_pill bottle/OmniLight3D_Pill",
	$"smoking dude/smoking dude_armature",
	$"backroom main parent/Cube_120_CLUB",
	$"backroom visual parent/Plane_020",
	$"backroom main parent",
	$"intro parent/backroom door/Cube_121",
	$"health counter main1/main counter/health counter parent",
	$"tabletop parent/tabletop interior_table pivot/tabletop interior device parent",
	$"tabletop parent/tabletop interior_table pivot/tabletop interior device parent_002",
	$"tabletop parent/tabletop interior_table pivot/tabletop interior device parent_004",
	$"tabletop parent/tabletop interior_table pivot/tabletop interior device parent_001"
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
@onready var bathroom_wall_main_crt_hole: MeshInstance3D = $"restroom_CLUB/bathroom wall main_crt hole"
@onready var animator_intro: AnimationPlayer = $"intro parent/animator_intro"
@onready var match_fixing: MeshInstance3D = $"restroom_CLUB/bathroom wall main_crt hole/MeshInstance3D_MatchFixing"
@onready var label_3d_gambling_manipulated: Label3D = $"tabletop parent/main tabletop/health counter/health counter ui parent/round indicator parent/Label3D_GamblingManipulated"
@onready var item_amounts: Amounts = $"standalone managers/item amounts"
@onready var interaction_branch_match_fixing: InteractionBranch = $"restroom_CLUB/bathroom wall main_crt hole/MeshInstance3D_MatchFixing/InteractionBranch_MatchFixing"
@onready var mesh_instance_3d_match_fixing: MeshInstance3D = $"restroom_CLUB/bathroom wall main_crt hole/MeshInstance3D_MatchFixing"

@onready var round_batchs:= [
	$"standalone managers/round batch array/round batch_0",
	$"standalone managers/round batch array/round batch_1",
	$"standalone managers/round batch array/round batch_2"
]

var starting_health:= {
	'enabled': false,
	'dealer': [0, 0, 0],
	'player': [0, 0, 0]
}

func _ready() -> void:
	OpenBRGlobal.is_multiplayer = false
	OpenBRGlobal.main = self
	#TranslationServer.set_locale('ZHS')
	init_invisible_nodes()
	viewblocker_parent.show()
	refresh_collision_shape()

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
			node.hide()
		if OpenBRConfig.fetch('visual', 'very_low_perf_mode', false):
			#for node in invisible_nodes_very_low_perf:
				#node.hide()
			#mesh_instance_3d_bridge.show()
			#color_rect_very_low_perf_shader.show()
			pass
	if OpenBRGlobal.WATCH_ONLY:
		for node in invisible_nodes_very_low_perf:
			if node != null: node.hide()
		$OmniLight3D_Extra.show()
	
	bathroom_wall_main_crt_hole.hide()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_BACK and event.is_pressed():
		print('Back')

func refresh_collision_shape():
	var vec:= get_window().size
	if (float(vec.x) / vec.y) < 1.32:
		collision_shape_3d_backroom_door.scale.z = 2.5

func load_gambling():
	print('Loading gambling')
	var gambling:String = OpenBRConfig.fetch('game', 'gambling')
	if gambling != 'default' and OpenBRConfig.hasKey('gamblings', gambling):
		label_3d_gambling_manipulated.show()
		var json:Array = JSON.parse_string(OpenBRConfig.fetch('gamblings', gambling, MatchFixingHandler.get_default_json()))
		
		if json.size() <= 3:
			json.push_back({
				'allow_all_items': false
			})
		if json[3].allow_all_items:
			for aa in range(item_amounts.array_amounts.size()):
				if aa >= 5:
					item_amounts.array_amounts[aa].amount_main = item_amounts.array_amounts[aa].amount_don
		
		for i in json.size():
			if i >= 3: return
			var level:Dictionary = json[i]
			var round_array:Array[RoundClass] = []
			for o in level['rounds'].size():
				round_array.push_back(new_round_class(i, o, level['rounds'][o], level['health_of_dealer'], level['health_of_player']))
			round_batchs[i].roundArray = round_array
			starting_health['enabled'] = true
	else:
		label_3d_gambling_manipulated.hide()
func new_round_class(level:int, index:int, json:Dictionary, d_hp:int, p_hp:int) -> RoundClass:
	var round:= RoundClass.new()
	round.hasIntroductoryText = false
	round.isFirstRound = false
	round.startingHealth = 0
	round.roundIndex = index
	round.amountBlank = json['number_of_blank_shells']
	round.amountLive = json['number_of_live_shells']
	round.usingItems = false
	round.showingIndicator = false
	round.indicatorNumber = 0
	round.bootingUpCounter = false
	round.sequenceHidden = false
	round.shufflingArray = false
	round.insertingInRandomOrder = true
	round.numberOfItemsToGrab = 0
	round.hasIntro2 = false
	
	if index == 0:
		round.isFirstRound = true
		round.bootingUpCounter = true
		round.showingIndicator = true
		round.startingHealth = max(d_hp,p_hp)
		round.indicatorNumber = level + 1
		if level == 2:
			round.hasIntro2 = true
	elif level == 2:
		round.shufflingArray = true
	if json['number_of_items'] != 0:
		round.usingItems = true
		round.numberOfItemsToGrab = json['number_of_items']
	starting_health['dealer'][level] = d_hp
	starting_health['player'][level] = p_hp
	
	return round

func interact_with(alias:String):
	match alias:
		'pill bottle':
			mesh_instance_3d_match_fixing.is_managered = true
			interaction_branch_match_fixing.interactionAllowed = false
		'pill choice no':
			mesh_instance_3d_match_fixing.is_managered = false
			interaction_branch_match_fixing.interactionAllowed = true
