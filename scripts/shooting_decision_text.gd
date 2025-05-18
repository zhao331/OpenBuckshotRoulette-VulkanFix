extends Label3D

func _process(delta: float) -> void:
	if OpenBRGlobal.is_mobile_renderer():
		modulate.a = (1 - transparency) * 10
