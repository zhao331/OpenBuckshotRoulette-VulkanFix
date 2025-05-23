extends Node
@onready var control_main: Control = $"../Control_Main"
@onready var item_list_gamblings: ItemList = $"../Control_Main/ItemList_Gamblings"
@onready var control_new_gambling: Control = $"../Control_NewGambling"
@onready var text_edit_new_gambling_name: TextEdit = $"../Control_NewGambling/TextEdit_NewGamblingName"
@onready var control_remove_yes_or_no: Control = $"../Control_RemoveYesOrNo"
@onready var label_remove_gambling: Label = $"../Control_Main/Label_Remove"
@onready var label_edit_gambling: Label = $"../Control_Main/Label_Edit"

@onready var pages:= [
	control_main,
	control_new_gambling,
	control_remove_yes_or_no
]

var selected_gambling:= 'default'

func _ready() -> void:
	switch_page(0)

func action(act:String):
	print('Match fixing action: ', act)
	match act:
		'switch_to_main':
			switch_page(0)
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
	match index:
		0:
			refresh_gamblings()
			item_list_gamblings_select(get_current_gambling())
		1:
			text_edit_new_gambling_name.clear()

func new_gambling(name:String):
	var file:= FileAccess.open('res://resources/default_gambling.json', FileAccess.READ)
	var template:= file.get_as_text()
	file.close()
	OpenBRConfig.put('gamblings', name, template)

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
