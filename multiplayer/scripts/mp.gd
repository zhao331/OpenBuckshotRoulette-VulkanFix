extends Node

const SERVER_ADDR:= '127.0.0.1:8051'
const LOBBY_TYPE_FRIENDS_ONLY:= 0

var Log:Logger
var peer:= ENetMultiplayerPeer.new()
@onready var lobby_manager: LobbyManager = $"../standalone managers/lobby manager"

func _ready() -> void:
	Log = Logger.new('_OpenBR_MP')

func create_lobby(flag:int, player_limit:int):
	Log.d('Creating lobby')
	peer.create_server(8051, player_limit)
	multiplayer.multiplayer_peer = peer
	peer.peer_connected.connect(func(id):
		Log.d('Peer connected: ', id)
	)
	peer.peer_disconnected.connect(func(id):
		Log.d('Peer disconnected: ', id)
	)
	lobby_manager._on_lobby_created(0, 114514)
	send({
		'action': 'create_lobby'
	})

func get_server_addr() -> String:
	return SERVER_ADDR

func connect_to_server():
	Log.d('Connecting to server: ', get_server_addr())
	peer.create_client(get_server_addr().split(':')[0], int(get_server_addr().split(':')[1]))
	multiplayer.multiplayer_peer = peer

func send(dic:Dictionary):
	print('Sending: ', dic)
	rpc('send_text', JSON.stringify(dic))

func action(act:String):
	match act:
		'join_game':
			connect_to_server()
		'test':
			send({
				'aaa': 'bbb'
			})

@rpc("any_peer")
func send_text(text:String):
	print('Text: ', text)
