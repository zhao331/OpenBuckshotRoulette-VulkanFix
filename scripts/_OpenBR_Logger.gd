class_name Logger extends Node

var _tag:= ''

func _init(tag:= ''):
	_tag = tag

func _print(type:= 'D', arg1 = '', arg2 = '', arg3 = '', arg4 = '', arg5 = ''):
	if _tag.is_empty():
		print(OpenBRGlobal.get_formatted_time(), ' ', type, ' ', arg1, arg2, arg3, arg4, arg5)
		return
	print(OpenBRGlobal.get_formatted_time(), ' ', type, ' [', _tag, '] ', arg1, arg2, arg3, arg4, arg5)

func d(arg1 = '', arg2 = '', arg3 = '', arg4 = '', arg5 = ''):
	_print('D', arg1, arg2, arg3, arg4, arg5)
