extends Resource
class_name AppInputs

"""
We want to allow for input => action mappings, just like the Godot InputMap.
We want scripted tasks that can also be assigned shortcuts.
Can then make a resource-powered GUI that generates the mapping editor
main toolbar can then populate records based on that data
"""

class Action:
	var shortcuts: Array
	var deadzone: int = 0.5

var _data = {}

func _get(p_property):
	if !_data.has(p_property):
		return
	return _data[p_property]

func _set(p_property, p_value):
	pass

func _get_property_list():
	pass