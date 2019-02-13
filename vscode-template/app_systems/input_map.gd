extends Node

"""
We want to allow for input => action mappings, just like the Godot InputMap.
We want scripted tasks that can also be assigned shortcuts.
Can then make a resource-powered GUI that generates the mapping editor
main toolbar can then populate records based on that data
"""

class Action:
	extends Reference
	var id: int
	var inputs: Array
	var deadzone: float = 0.5

const ALL_DEVICES := -1

var input_map = {}
var last_id = 1

enum Errors {
	ACTION_DOES_NOT_EXIST
}
const Messages = {
	Errors.ACTION_DOES_NOT_EXIST: "Attempted to access nonexistent action"
}

func _find_event(p_action: Action, p_event: InputEvent, p_params: Dictionary = {}) -> Dictionary:
	return {}

func has_action(p_action: String) -> bool:
	return input_map.has(p_action)

func get_actions() -> Array:
	return input_map.keys()

func add_action(p_action: String, p_deadzone: float = 0.5) -> void:
	if not input_map.has(p_action):
		printerr("not input_map.has(p_action)")
		return
	input_map[p_action] = Action.new()
	last_id = 1
	input_map[p_action].id = last_id
	input_map[p_action].deadzone = p_deadzone
	last_id += 1

func erase_action(p_action: String) -> void:
	assert input_map.has(p_action)
	input_map.erase(p_action)

func action_set_deadzone(p_action: String, p_deadzone: float) -> void:
	assert input_map.has(p_action)
	input_map[p_action].deadzone = p_deadzone

func action_add_event(p_action: String, p_event: InputEvent) -> void:
	assert p_event
	assert input_map.has(p_action)
	if _find_event(input_map[p_action], p_event):
		return
	input_map[p_action].inputs.append(p_event)

func action_has_event(p_action: String, p_event: InputEvent) -> void:
	if not input_map.has(p_action):
		assert false

func action_erase_event(p_action: String, p_event: InputEvent) -> void:
	pass

func action_erase_events(p_action: String) -> void:
	pass

func event_is_action(p_event: InputEvent) -> bool:
	return false

func event_get_action_status(p_event: InputEvent, p_action: String) -> Dictionary:
	return {}

func get_action_map() -> Dictionary:
	return input_map

func load_from_globals() -> void:
	pass

func load_defaults() -> void:
	pass