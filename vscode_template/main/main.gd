extends Control

func _ready():
	var action = AppInputActions.new()
	var props = action.get_property_list()
	print("get_property_list()")
	for a_prop in props:
		print(a_prop.name)
	props = action._get_property_list()
	print("_get_property_list()")
	for a_prop in props:
		print(a_prop.name)
