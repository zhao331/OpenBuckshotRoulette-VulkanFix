extends Node
class_name MP
const PROTOCOL:= 1

@export var interaction_branch_bathroom_door: InteractionBranch
@export var interaction_manager: InteractionManagerMP
@export var shell_spawner: ShellSpawnerMP
@export var permission_manager: PermissionManager

signal on_response_get_server_info(info:Dictionary)
signal on_response_get_shells(shells:Array)

@onready var control: Control = $Control
@onready var control_main: Control = $Control/Control_Main
@onready var control_wait_for_player: Control = $Control/Control_WaitForPlayer
@onready var control_disconnected: Control = $Control/Control_Disconnected

@onready var visibles:= [
	control,
	control_main
]
@onready var invisibles:= [
	control_wait_for_player,
	control_disconnected
]

var peer:= ENetMultiplayerPeer.new()

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
			peer.create_server(8050, 4)
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
			peer.create_client('127.0.0.1', 8050)
			peer.peer_disconnected.connect(func(id):
				control.show()
				control_disconnected.show()
				interaction_branch_bathroom_door.interactionAllowed = false
			)
			control.hide()
			control_main.hide()
			interaction_branch_bathroom_door.interactionAllowed = true
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
	if multiplayer.get_peers().size() <= 0: return 0
	return multiplayer.get_peers()[0]

func is_server() -> bool:
	return multiplayer.is_server()

@rpc("any_peer")
func rpc_talk(id:int, match_id:int, msg:String):
	if id == get_id(): return
	print('From ', id, ': ', msg)

func _rpc_talk(msg:String):
	rpc_id(get_opponent_id(), 'rpc_talk', get_id(), 0, msg)

@rpc('any_peer')
func rpc_get_server_info(id:int):
	if id == get_id(): return
	if multiplayer.is_server():
		_rpc_on_signal(on_response_get_server_info, {
			'version_name': GlobalVariables.currentVersion_nr,
			'version_code': 9,
			'protocol': PROTOCOL,
			'type': 'client'
		})

func _rpc_get_server_info(id:int):
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
	print('request get shells')
	rpc_id(get_opponent_id(), 'rpc_get_shells', 0)

@rpc('any_peer')
func rpc_on_signal(id:int, match_id:int, _signal:Signal, data:Dictionary):
	print('Signal ', _signal, ' ', data)
	match _signal:
		on_response_get_shells:
			on_response_get_shells.emit(data.shells)

func _rpc_on_signal(_signal:Signal, data:Dictionary):
	rpc_id(get_opponent_id(), 'rpc_on_signal', get_id(), 0, _signal, data)
