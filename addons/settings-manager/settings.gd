extends Node

signal setting_changed # emitted with name, value
signal settings_saved
signal settings_loaded # emitted when settings are loaded from file, needs to be connected in _init()

const DEBUG_SETTINGS = true
const SETTINGS_PATH = "user://settings.json"
const SETTINGS_DEF = {
	"example_1": {
		"name": "Example Toggle",
		"description": "resets every restart", # optional
		"flags": ["no_save"], # optional
		"type": "bool",
		"default": false
	},
	"example_2": {
		"name": "Example Number",
		"type": "number",
		"default": 42,
		"min": 1, # optional
		"max": 100, # optional
		"step": 4 # optional
	},
	"example_3": {
		"name": "Example section",
		"type": "dict",
		"default": {
			"example_4": {
				"name": "Example text",
				"type": "string",
				"default": "hello world"
			},
			"example_5": {
				"name": "Example Vector3",
				"type": "vector3",
				"default": Vector3(1,2,3)
			},
			"example_6": {
				"name": "Example Quat",
				"type": "quat",
				"default": Quat()
			}
		}
	},
}

var s: Dictionary = {}


func _ready() -> void:
	_init_settings()
	load_settings()
	emit_signal("settings_loaded")
	save_settings()



func _init_settings() -> void:
	for key in SETTINGS_DEF:
		s[key] = _init_sub_setting(key, SETTINGS_DEF)
	if DEBUG_SETTINGS:
		print("Default settings: ", s)


func _init_sub_setting(key, def):
	match def[key].type:
		"dict":
			var _s = {}
			for k in def[key].default:
				_s[k] = _init_sub_setting(k, def[key].default)
			return _s
		_:
			return def[key].default


func save_settings():
	var to_save = {}
	for key in s:
		var val = _save_sub_setting(key, s, SETTINGS_DEF)
		if val != null:
			to_save[key] = val

	var file = File.new()
	file.open(SETTINGS_PATH, File.WRITE)
	file.store_line(to_json(to_save))
	file.close()


func _save_sub_setting(key, settings, def):
	if def[key].has("flags") and "no_save" in def[key].flags:
		return null
	match def[key].type:
		"vector2":
			return [settings[key].x, settings[key].y]
		"vector3":
			return [settings[key].x, settings[key].y, settings[key].z]
		"quat":
			return [settings[key].x, settings[key].y, settings[key].z, settings[key].w]
		"dict":
			var _s = {}
			for k in settings[key]:
				var v = _save_sub_setting(k, settings[key], def[key].default)
				if v != null:
					_s[k] = v
			return _s
		_:
			return settings[key]


func load_settings() -> void:
	var file = File.new()

	if not file.file_exists(SETTINGS_PATH):
		if DEBUG_SETTINGS:
			print("No settings file exists, using defaults")
		return

	file.open(SETTINGS_PATH, File.READ)
	var new_settings = parse_json(file.get_as_text())
	file.close()

	for key in new_settings:
		s[key] = _load_sub_setting(key, new_settings[key], SETTINGS_DEF)

	if DEBUG_SETTINGS:
		print("Loaded settings from file")
		print(s)


func _load_sub_setting(key, val, def):
	match def[key].type:
		"vector2":
			return Vector2(val[0], val[1])
		"vector3":
			return Vector3(val[0], val[1], val[2])
		"quat":
			return Quat(val[0], val[1], val[2], val[3])
		"dict":
			var _s = {}
			for k in val:
				_s[k] = _load_sub_setting(k, val[k], def[key].default)
			return _s
		_:
			return val


func _exit_tree() -> void:
	# save on quit
	save_settings()


func _on_AutosaveTimer_timeout() -> void:
	# auto saves every 5 minutes, saving should also be done manually
	save_settings()
