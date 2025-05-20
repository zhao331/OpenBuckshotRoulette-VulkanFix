extends Control

func _ready() -> void:
	hide()

func change(path:String) -> void:
	print('Changing scene to: ', path)
	show()
	await get_tree().change_scene_to_file(path)
	await OpenBRGlobal.sleep(0.01)
	hide()
	print('Changed scene to: ', path)
