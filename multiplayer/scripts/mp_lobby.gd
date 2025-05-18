extends Node3D

@onready var visible_nodes:= [
	$ui/viewblocker,
	$"ui/vhs bleed",
	$"ui/vhs grain"
]

func _ready() -> void:
	TranslationServer.set_locale('ZHS')
	init_visible_nodes()

func init_visible_nodes():
	for node in visible_nodes:
		node.show()
