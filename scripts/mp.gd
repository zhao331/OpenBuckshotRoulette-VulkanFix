extends Node
class_name MP
const PROTOCOL:= 1

@export var interaction_branch_bathroom_door: InteractionBranch
@export var interaction_manager: InteractionManagerMP
@export var shell_spawner: ShellSpawnerMP
@export var permission_manager: PermissionManager
@export var dealer: DealerIntelligenceMP

signal on_response_get_server_info(info:Dictionary)
signal on_response_get_shells(shells:Array)

@onready var control: Control = $Control
@onready var control_main: Control = $Control/Control_Main
@onready var control_wait_for_player: Control = $Control/Control_WaitForPlayer
@onready var control_disconnected: Control = $Control/Control_Disconnected
@onready var label_wait_for_player: Label = $Control/Control_WaitForPlayer/Label_WaitForPlayer
@onready var text_edit_match_addr: TextEdit = $Control/Control_JoinMatch/TextEdit
@onready var control_join_match: Control = $Control/Control_JoinMatch

@onready var visibles:= [
	control,
	control_main
]
@onready var invisibles:= [
	control_wait_for_player,
	control_disconnected,
	control_join_match
]

var peer:= ENetMultiplayerPeer.new()
var oppenent_id:= 0

func _ready() -> void:
	interaction_branch_bathroom_door.interactionAllowed = false
	
	for node in invisibles:
		if node != null: node.hide()
	for node in visibles:
		if node != null: node.show()

func action(act:String):
	match act:
		'create_match':
			control_main.hide()
			control_wait_for_player.show()
			peer.create_server(34952, 1)
			peer.peer_connected.connect(func(id):
				control.hide()
				control_wait_for_player.hide()
				interaction_branch_bathroom_door.interactionAllowed = true
			)
			peer.peer_disconnected.connect(func(id):
				control.show()
				control_disconnected.show()
				interaction_branch_bathroom_door.interactionAllowed = false
			)
			multiplayer.multiplayer_peer = peer
		'join_match':
			control_main.hide()
			control_join_match.show()
		'cancel_join':
			control_main.show()
			control_join_match.hide()
		'true_join':
			peer.create_client(text_edit_match_addr.text, 34952)
			control_main.hide()
			control_join_match.hide()
			control_wait_for_player.show()
			peer.peer_disconnected.connect(func(id):
				control.show()
				control_disconnected.show()
				interaction_branch_bathroom_door.interactionAllowed = false
			)
			peer.peer_connected.connect(func(id):
				oppenent_id = id
				control_wait_for_player.hide()
				control.hide()
				interaction_branch_bathroom_door.interactionAllowed = true
				await OpenBRGlobal.sleep(0.05)
				on_response_get_server_info.connect(func(info:Dictionary):
					if info.protocol != PROTOCOL:
						label_wait_for_player.text = tr('PROTOCOL_VERSION_NOT_SUPPORTED')
						peer.disconnect_peer(get_opponent_id())
					else:
						control_wait_for_player.hide()
						control.hide()
						interaction_branch_bathroom_door.interactionAllowed = true
				)
				_rpc_get_server_info()
			)
			multiplayer.multiplayer_peer = peer

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('debug_r_alt'): rpc_id(get_opponent_id(), 'rpc_talk', get_id(), 0, 'hello')
	#if Input.is_action_just_pressed('debug_.'): interaction_manager.InteractWith('bathroom door')
	#if Input.is_action_just_pressed('debug_;'): rpc_interact_with(get_id(), 0, 'bathroom door')
func _exit_tree() -> void:
	peer.disconnect_peer(get_opponent_id())

func get_id() -> int:
	return multiplayer.get_unique_id()

func get_opponent_id() -> int:
	#print('Opponent id: ', oppenent_id)
	#return oppenent_id
	if multiplayer.get_peers().size() <= 0: return 0
	return multiplayer.get_peers()[0]

func is_server() -> bool:
	return multiplayer.is_server()

func interact_with(alias:String):
	match alias:
		'shotgun':
			_rpc_pick_up_shotgun()
		'text dealer':
			_rpc_shoot(get_opponent_id())
		'text you':
			_rpc_shoot(get_id())

@rpc("any_peer")
func rpc_talk(id:int, match_id:int, msg:String):
	if id == get_id(): return
	print('From ', id, ': ', msg)

func _rpc_talk(msg:String):
	rpc_id(get_opponent_id(), 'rpc_talk', get_id(), 0, msg)

@rpc('any_peer')
func rpc_get_server_info(id:int):
	print('Sending server info')
	_rpc_on_signal(on_response_get_server_info, {
		'info': {
			'version_name': GlobalVariables.currentVersion_nr,
			'version_code': 9,
			'protocol': PROTOCOL,
			'type': 'client'
		}
	})

func _rpc_get_server_info():
	print('Getting server info')
	rpc_id(get_opponent_id(), 'rpc_get_server_info', get_id())

@rpc('any_peer')
func rpc_interact_with(id:int, match_id:int, alias:String):
	if id == get_id() or (alias != 'bathroom door' and alias != 'backroom door'): return
	if multiplayer.is_server(): print('From client: rpc_interact_with ', alias, ' by ', id)
	else: print('From server: rpc_interact_with ', alias, ' by ', id)
	interaction_manager.InteractWith('no_rpc ' + alias)

func _rpc_interact_with(alias:String):
	rpc_id(get_opponent_id(), 'rpc_interact_with', get_id(), 0, alias)

@rpc('any_peer')
func rpc_get_shells(match_id:int):
	var timer:= Timer.new()
	add_child(timer)
	timer.wait_time = 0.05
	timer.one_shot = true
	timer.timeout.connect(func():
		if shell_spawner.sequenceArray.size() <= 0: timer.start()
		else:
			timer.stop()
			_rpc_on_signal(on_response_get_shells, {
				'shells': shell_spawner.sequenceArray
			})
	)
	timer.start()

func _rpc_get_shells():
	rpc_id(get_opponent_id(), 'rpc_get_shells', 0)

@rpc('any_peer')
func rpc_on_signal(id:int, match_id:int, _signal:Signal, data:Dictionary):
	print('Recived signal ', _signal.get_name(), ': ', data)
	match _signal.get_name():
		'on_response_get_shells':
			on_response_get_shells.emit(data.shells)
		'on_response_get_server_info':
			on_response_get_server_info.emit(data.info)

func _rpc_on_signal(_signal:Signal, data:Dictionary):
	print('Sending signal ', _signal.get_name(), ': ', data)
	rpc_id(get_opponent_id(), 'rpc_on_signal', get_id(), 0, _signal, data)

@rpc('any_peer')
func rpc_pick_up_shotgun(id:int, match_id:int):
	dealer.pick_up_shotgun()

func _rpc_pick_up_shotgun():
	rpc_id(get_opponent_id(), 'rpc_pick_up_shotgun', get_id(), 0)

@rpc('any_peer')
func rpc_shoot(id:int, match_id:int, target_id:int):
	if target_id == get_id(): dealer.Shoot('player')
	else: dealer.Shoot('self')

func _rpc_shoot(target_id:int):
	print('_rpc_shoot: ', target_id)
	rpc_id(get_opponent_id(), 'rpc_shoot', get_id(), 0, target_id)
