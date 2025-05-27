extends Node
class_name MatchFixingHandler

@onready var control_main: Control = $"../Control_Main"
@onready var item_list_gamblings: ItemList = $"../Control_Main/ItemList_Gamblings"
@onready var control_new_gambling: Control = $"../Control_NewGambling"
@onready var text_edit_new_gambling_name: TextEdit = $"../Control_NewGambling/TextEdit_NewGamblingName"
@onready var control_remove_yes_or_no: Control = $"../Control_RemoveYesOrNo"
@onready var label_remove_gambling: Label = $"../Control_Main/Label_Remove"
@onready var label_edit_gambling: Label = $"../Control_Main/Label_Edit"
@onready var control_editor: Control = $"../Control_Editor"
@onready var tab_container_levels: TabContainer = $"../Control_Editor/TabContainer_Levels"
@onready var control_round_editor: Control = $"../Control_RoundEditor"
@onready var label_true_item_count: Label = $"../Control_RoundEditor/Panel/Label_TrueItemCount"
@onready var label_true_blank_count: Label = $"../Control_RoundEditor/Panel/Label_TrueBlankCount"
@onready var label_true_live_count: Label = $"../Control_RoundEditor/Panel/Label_TrueLiveCount"
@onready var animation_player: AnimationPlayer = $"../Control_RoundEditor/Panel/AnimationPlayer"
@onready var label_return: Label = $"../Label_Return"
@onready var label_active_gambling: Label = $"../Control_Main/Label_ActiveGambling"
@onready var checkbox_allow_all_items: Checkbox = $"../Control_Editor/Control_AllowAllItems/Checkbox_AllowAllItems"

@onready var pages:= [
	control_main,
	control_new_gambling,
	control_remove_yes_or_no,
	control_editor,
	control_round_editor
]
@onready var levels:= [
	{
		'rounds': $"../Control_Editor/TabContainer_Levels/Control_Level1/ItemList_Rounds",
		'player_HP': $"../Control_Editor/TabContainer_Levels/Control_Level1/Label_TruePlayerHP",
		'dealer_HP': $"../Control_Editor/TabContainer_Levels/Control_Level1/Label_TrueDealerHP"
	},
	{
		'rounds': $"../Control_Editor/TabContainer_Levels/Control_Level2/ItemList_Rounds",
		'player_HP': $"../Control_Editor/TabContainer_Levels/Control_Level2/Label_TruePlayerHP",
		'dealer_HP': $"../Control_Editor/TabContainer_Levels/Control_Level2/Label_TrueDealerHP"
	},
	{
		'rounds': $"../Control_Editor/TabContainer_Levels/Control_Level3/ItemList_Rounds",
		'player_HP': $"../Control_Editor/TabContainer_Levels/Control_Level3/Label_TruePlayerHP",
		'dealer_HP': $"../Control_Editor/TabContainer_Levels/Control_Level3/Label_TrueDealerHP"
	}
]

var selected_gambling:= 'default'
var selected_level:= 0
var selected_round:= 0

var gambling_json:Array

func _ready() -> void:
	switch_page(0)

func action(act:String):
	print('Match fixing action: ', act)
	match act:
		'switch_to_main':
			switch_page(0)
		'switch_to_editor':
			switch_page(3)
		'new_gambling':
			switch_page(1)
		'true_new_gambling':
			var name:= text_edit_new_gambling_name.text
			name = name.strip_edges().to_lower()
			if name != 'default' and !OpenBRConfig.hasKey('gamblings', name):
				new_gambling(name)
				switch_page(0)
		'remove_gambling':
			if selected_gambling != 'default':
				switch_page(2)
		'true_remove_gambling':
			OpenBRConfig.remove('gamblings', selected_gambling)
			switch_page(0)
		'edit_gambling':
			init_gambling_editor()
		'save':
			OpenBRConfig.put('gamblings', selected_gambling, JSON.stringify(gambling_json))
			switch_page(0)
		'select_gambling':
			OpenBRConfig.put('game', 'gambling', selected_gambling)
			label_active_gambling.text = tr('CURRENT_GAMBLING') + ': ' + selected_gambling
		'player_HP_plus':
			if gambling_json[selected_level]['health_of_player'] >= 6: return
			gambling_json[selected_level]['health_of_player'] += 1
			levels[selected_level]['player_HP'].text = str(int(gambling_json[selected_level]['health_of_player']))
		'player_HP_reduce':
			if gambling_json[selected_level]['health_of_player'] <= 1: return
			gambling_json[selected_level]['health_of_player'] -= 1
			levels[selected_level]['player_HP'].text = str(int(gambling_json[selected_level]['health_of_player']))
		'dealer_HP_plus':
			if gambling_json[selected_level]['health_of_dealer'] >= 6: return
			gambling_json[selected_level]['health_of_dealer'] += 1
			levels[selected_level]['dealer_HP'].text = str(int(gambling_json[selected_level]['health_of_dealer']))
		'dealer_HP_reduce':
			if gambling_json[selected_level]['health_of_dealer'] <= 1: return
			gambling_json[selected_level]['health_of_dealer'] -= 1
			levels[selected_level]['dealer_HP'].text = str(int(gambling_json[selected_level]['health_of_dealer']))
		'remove_round':
			var list:ItemList = levels[selected_level]['rounds']
			if list.item_count < selected_round + 1 or gambling_json[selected_level]['rounds'].size() <= 1: return
			gambling_json[selected_level]['rounds'].erase(gambling_json[selected_level]['rounds'][selected_round])
			list.remove_item(selected_round)
			list.select(0)
			_on_item_list_rounds_item_selected(0)
		'new_round':
			var list:ItemList = levels[selected_level]['rounds']
			gambling_json[selected_level]['rounds'].push_back({
				'number_of_items': 0,
				'number_of_blank_shells': 1,
				'number_of_live_shells': 1
			})
			list.add_item(tr('NEW_ROUND'))
		'item_count_plus':
			var round:Dictionary = gambling_json[selected_level]['rounds'][selected_round]
			if round['number_of_items'] >= 8: return
			round['number_of_items'] += 1
			label_true_item_count.text = str(int(round['number_of_items']))
			gambling_json[selected_level]['rounds'][selected_round] = round
		'item_count_reduce':
			var round:Dictionary = gambling_json[selected_level]['rounds'][selected_round]
			if round['number_of_items'] <= 0: return
			round['number_of_items'] -= 1
			label_true_item_count.text = str(int(round['number_of_items']))
			gambling_json[selected_level]['rounds'][selected_round] = round
		'blank_count_plus':
			var round:Dictionary = gambling_json[selected_level]['rounds'][selected_round]
			if round['number_of_blank_shells'] >= 8: return
			round['number_of_blank_shells'] += 1
			label_true_blank_count.text = str(int(round['number_of_blank_shells']))
			gambling_json[selected_level]['rounds'][selected_round] = round
		'blank_count_reduce':
			var round:Dictionary = gambling_json[selected_level]['rounds'][selected_round]
			if round['number_of_blank_shells'] <= 0: return
			round['number_of_blank_shells'] -= 1
			label_true_blank_count.text = str(int(round['number_of_blank_shells']))
			gambling_json[selected_level]['rounds'][selected_round] = round
		'live_count_plus':
			var round:Dictionary = gambling_json[selected_level]['rounds'][selected_round]
			if round['number_of_live_shells'] >= 8: return
			round['number_of_live_shells'] += 1
			label_true_live_count.text = str(int(round['number_of_live_shells']))
			gambling_json[selected_level]['rounds'][selected_round] = round
		'live_count_reduce':
			var round:Dictionary = gambling_json[selected_level]['rounds'][selected_round]
			if round['number_of_live_shells'] <= 0: return
			round['number_of_live_shells'] -= 1
			label_true_live_count.text = str(int(round['number_of_live_shells']))
			gambling_json[selected_level]['rounds'][selected_round] = round
		'save_round':
			var round:Dictionary = gambling_json[selected_level]['rounds'][selected_round]
			var blanks:int = round['number_of_blank_shells']
			var lives:int = round['number_of_live_shells']
			if blanks + lives > 8 or blanks + lives <= 0: animation_player.play("warn")
			#elif lives <= 0: animation_player.play("warn_lives")
			else:
				switch_page(3)
		'edit_round':
			init_round_editor()
		'new_gambling_backspace':
			var text:= text_edit_new_gambling_name.text
			if text.length() >= 1: text_edit_new_gambling_name.text = text.substr(0, text.length() - 1)
		'allow_all_items_on':
			gambling_json[3].allow_all_items = true
		'allow_all_items_off':
			gambling_json[3].allow_all_items = false

func refresh_gamblings():
	item_list_gamblings.clear()
	item_list_gamblings.add_item('default')
	var gamblings:= OpenBRConfig.keys('gamblings')
	for gambling_name in gamblings:
		item_list_gamblings.add_item(gambling_name)

func switch_page(index:= 0):
	for page in pages:
		page.hide()
	pages[index].show()
	label_return.hide()
	match index:
		0:
			refresh_gamblings()
			item_list_gamblings_select(get_current_gambling())
			label_return.show()
			label_active_gambling.text = tr('CURRENT_GAMBLING') + ': ' + get_current_gambling()
		1:
			text_edit_new_gambling_name.clear()
		3:
			tab_container_levels.set_tab_title(0, tr('LEVEL') % '1')
			tab_container_levels.set_tab_title(1, tr('LEVEL') % '2')
			tab_container_levels.set_tab_title(2, tr('LEVEL') % '3')
		

func new_gambling(name:String):
	OpenBRConfig.put('gamblings', name, get_default_json())

static func get_default_json():
	var file:= FileAccess.open('res://resources/default_gambling.json', FileAccess.READ)
	var template:= file.get_as_text()
	file.close()
	return template

func get_current_gambling() -> String:
	var gambling:String = OpenBRConfig.fetch('game', 'gambling', 'default')
	if OpenBRConfig.hasKey('gamblings', gambling): return gambling
	return 'default'

func item_list_gamblings_select(name:= 'default'):
	for i in item_list_gamblings.item_count:
		if item_list_gamblings.get_item_text(i) == name:
			item_list_gamblings.select(i)
			_on_item_list_gamblings_item_selected(i)
			return
	item_list_gamblings.select(0)
	_on_item_list_gamblings_item_selected(0)


func _on_item_list_gamblings_item_selected(index: int) -> void:
	selected_gambling = item_list_gamblings.get_item_text(index)
	if selected_gambling == 'default':
		label_remove_gambling.hide()
		label_edit_gambling.hide()
	else:
		label_remove_gambling.show()
		label_edit_gambling.show()
	pass # Replace with function body.

func init_gambling_editor():
	switch_page(3)
	tab_container_levels.current_tab = 0
	_on_tab_container_levels_tab_selected(0)
	
	gambling_json = JSON.parse_string(OpenBRConfig.fetch('gamblings', selected_gambling, get_default_json()))
	
	if gambling_json.size() <= 3:
		gambling_json.push_back({
			'allow_all_items': false
		})
		
	var config:Dictionary = gambling_json[3]
	if config.has('allow_all_items') && config.allow_all_items: checkbox_allow_all_items.set_checked(1)
	
	for i in range(3):
		var level:Dictionary = gambling_json[i]
		levels[i]['player_HP'].text = str(int(level['health_of_player']))
		levels[i]['dealer_HP'].text = str(int(level['health_of_dealer']))
		
		var list:ItemList = levels[i]['rounds']
		list.clear()
		for o in level['rounds'].size():
			var round:Dictionary = level['rounds'][o]
			list.add_item(tr('ROUND') % o)
		list.select(0)

func _on_tab_container_levels_tab_selected(tab: int) -> void:
	selected_level = tab
	if levels.size() >= 1:
		var list:ItemList = levels[tab]['rounds']
		if list.item_count >= 1: list.select(0)
	_on_item_list_rounds_item_selected(0)
	pass # Replace with function body.

func _on_item_list_rounds_item_selected(index: int) -> void:
	selected_round = index
	pass # Replace with function body.

func init_round_editor():
	switch_page(4)
	var round:Dictionary = gambling_json[selected_level]['rounds'][selected_round]
	label_true_item_count.text = str(int(round['number_of_items']))
	label_true_blank_count.text = str(int(round['number_of_blank_shells']))
	label_true_live_count.text = str(int(round['number_of_live_shells']))
