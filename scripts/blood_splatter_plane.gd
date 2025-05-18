extends MeshInstance3D

func _process(delta: float) -> void:
	if OpenBRGlobal.is_mobile_renderer():
		var value:= 1 - transparency
		material_override.albedo_color.r = value
		material_override.albedo_color.g = value
		material_override.albedo_color.b = value
