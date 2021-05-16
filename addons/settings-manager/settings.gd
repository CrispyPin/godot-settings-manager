extends Node


const DEBUG_SETTINGS = false
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
        "name": "Example text",
        "type": "string",
        "default": "hello world"
    },
    "example_4": {
        "name": "Example Vector3",
        "type": "vector3",
        "default": Vector3(1,2,3)
    }
}

var settings_loaded = false
var paused = false
var settings = {}


func _ready() -> void:
    _init_settings()
    load_settings()
    settings_loaded = true
    get_node("/root/Default").queue_free()


func get_setting(key):
    return settings[key]


func set_setting(key, val):
    settings[key] = val
    if DEBUG_SETTINGS:
        print("Settings changed: ", key, " -> ", val)
    save_settings()


func _init_settings():
    for key in SETTINGS_DEF:
        settings[key] = SETTINGS_DEF[key].default
    if DEBUG_SETTINGS:
        print("Default settings: ", settings)


func save_settings():
    var file = File.new()
    file.open(SETTINGS_PATH, File.WRITE)
    file.store_line(to_json(settings))
    file.close()


func load_settings() -> void:
    var file = File.new()

    if not file.file_exists(SETTINGS_PATH):
        if DEBUG_SETTINGS:
            print("No settings file exists, using defaults")
        return

    file.open(SETTINGS_PATH, File.READ)
    var new_settings = parse_json(file.get_as_text())
    file.close()

    # in case settings format has changed, this is better than just clonging blindly
    for key in new_settings:
        if settings.has(key):
            settings[key] = new_settings[key]
    save_settings()
    if DEBUG_SETTINGS:
        print("Loaded settings from file")
        print(settings)

