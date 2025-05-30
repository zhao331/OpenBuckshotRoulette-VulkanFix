extends InteractionManager
class_name InteractionManagerMP

@export var mp:MP

func InteractWith(alias:String):
	if alias.ends_with('ending_finish'):
		super.InteractWith(alias)
		return
	print('interact_with ', alias)
	if mp != null && !alias.begins_with('no_rpc'):
		mp._rpc_interact_with(alias)
		mp.interact_with(alias)
	elif alias.begins_with('no_rpc'):
		alias = alias.substr('no_rpc '.length())
		print('processed_interaction: ', alias)
	super.InteractWith(alias)
