class_name ObjectShaker extends Node

@export var obj : Node3D
@export var delay : float
@export var offset_1 : float
@export var offset_2 : float

var originalPos : Vector3
var shaking = false

func StartShaking():
	originalPos = obj.transform.origin
	shaking = true
	ShakeRoutine()

func StopShaking():
	shaking = false
	obj.transform.origin = originalPos

func ShakeRoutine():
	var tree:= get_tree()
	if tree == null: tree = OpenBrGlobal.fetch_tree()
	while(shaking):
		var val = randf_range(offset_1, offset_2)
		var pos = Vector3(obj.transform.origin.x + val, obj.transform.origin.y + val, obj.transform.origin.z + val)
		obj.transform.origin = pos
		await tree.create_timer(delay, false).timeout
		obj.transform.origin = originalPos
		await tree.create_timer(delay, false).timeout
	pass
