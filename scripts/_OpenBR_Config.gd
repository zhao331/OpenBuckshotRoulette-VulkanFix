extends Node

const PATH := 'user://options.ini'

var cfg:ConfigFile

func _ready() -> void:
	cfg = ConfigFile.new()
	cfg.load(PATH)

func fetch(section:String, key:String, def = ''):
	return cfg.get_value(section, key, def)

func put(section:String, key:String, value):
	cfg.set_value(section, key, value)
	cfg.save(PATH)

func removeSection(section:String):
	cfg.erase_section(section)
	cfg.save(PATH)

func hasKey(section:String, key:String) -> bool:
	return cfg.has_section_key(section, key)

func keys(section:String):
	return cfg.get_section_keys(section)
