extends Node

const SERVER_ADDR:= 'ws://127.0.0.1:8050'
const LOBBY_TYPE_FRIENDS_ONLY:= 0

var Log:Logger
var client:= WebSocketPeer.new()

func _ready() -> void:
	Log = Logger.new('_OpenBR_MP')
	connect_to_server()

func create_lobby(flag:int, player_limit:int):
	Log.d('Creating lobby')
	send({
		'action': 'create_lobby'
	})

func get_server_addr() -> String:
	return SERVER_ADDR

func connect_to_server():
	Log.d('Connecting to server: ', get_server_addr())
	client.connect_to_url(get_server_addr())
	await get_tree().create_timer(1).timeout
	client.poll()
	Log.d('Connected: ', client.get_ready_state())

func send(dic:Dictionary):
	client.send_text(JSON.stringify(dic))
