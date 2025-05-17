extends Label3D

func _process(delta: float) -> void:
	if OpenBrGlobal.is_mobile_renderer():
		modulate.a = (1 - transparency) * 10
