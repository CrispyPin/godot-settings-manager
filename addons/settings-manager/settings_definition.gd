extends Node

const DEF = {
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
		"default": 42
	},
	"example_3": {
		"name": "Example section",
		"type": "dict",
		"definition": {
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
	"example_7": {
		"name": "Example array",
		"type": "array",
		"default": [1,23,4]
	},
	"example_8": {
		"name": "Example dict with varying size containing arrays",
		"type": "dict",
		"flags": ["resize"],
		"definition": {
			"type": "array",
			"default": [99,45,1] # does nothing on its own
		},
		"default": {
			"default_array": [1,2,3]
		}
	},
	"example_9": {
		"name": "Example dict with varying size containing more dicts",
		"type": "dict",
		"flags": ["resize"],
		"definition": {
			"type": "dict",
			"definition": {
				"property1": {
					"name": "Property 1",
					"type": "number",
					"default": 123 # does nothing on its own
				},
				"property2": {
					"name": "Property 2",
					"type": "number",
					"default": 345 # does nothing on its own
				},
			}
		},
		"default": {
			"item1": {
				"property1": 9000,
				"property2": 420
			}
		}
	},
}
