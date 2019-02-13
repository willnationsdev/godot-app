# author: willnationsdev
# license: MIT
# description: 
# imports: 
tool
extends ConfirmationDialog
class_name DeviceInput

##### CLASSES #####

##### SIGNALS #####

signal input_action_event_added(event, name)

##### CONSTANTS #####

const ALL_DEVICES = -1

##### PROPERTIES #####

var device_id: OptionButton = null
var device_index: OptionButton = null
var device_index_label: Label = null

##### NOTIFICATIONS #####

func _init():
	get_ok().text = tr("Add")
	connect("confirmed", self, "_device_input_add")

	var hbc = HBoxContainer.new()
	add_child(hbc)

	var vbc_left = VBoxContainer.new()
	hbc.add_child(vbc_left)

	var l = Label.new()
	l.text = tr("Device:")
	vbc_left.add_child(l)

	device_id = OptionButton.new()
	for i in range(-1, 8):
		device_id.add_item(get_device_string(i))
	set_current_device(0)
	vbc_left.add_child(device_id)

	var vbc_right = VBoxContainer.new()
	hbc.add_child(vbc_right)
	vbc_right.set_h_size_flags(SIZE_EXPAND_FILL)

	l = Label.new()
	l.text = tr("Index:")
	vbc_right.add_child(l)
	device_index_label = l

	device_index = OptionButton.new()
	vbc_right.add_child(device_index)

##### OVERRIDES #####

##### VIRTUALS #####

##### PUBLIC METHODS #####

func get_device_string(p_device_id: int):
	if p_device_id == ALL_DEVICES:
		return tr("All Devices")
	return tr("Device") + " " + str(p_device_id)

func set_current_device(p_device_id: int):
	device_id.select(p_device_id + 1)

func get_current_device() -> int:
	return device_id.selected - 1

func get_selected_device_index() -> int:
	return device_index.selected

##### PRIVATE METHODS #####

##### CONNECTIONS #####

##### SETTERS AND GETTERS #####
