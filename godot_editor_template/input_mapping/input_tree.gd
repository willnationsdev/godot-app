# author: willnationsdev
# license: MIT
# description:
#   This class provides a Tree interface for editing the InputMap's values.
# imports: PressAKey, DeviceInput
tool
extends Tree
class_name InputTree

##### CLASSES #####

##### SIGNALS #####

signal error_occurred(message)

##### CONSTANTS #####

enum InputType {
	INPUT_KEY,
	INPUT_JOY_BUTTON,
	INPUT_JOY_MOTION,
	INPUT_MOUSE_BUTTON
}

enum Column {
	ACTION,
	DEADZONE,
	OPTIONS,
	MAX
}

##### PROPERTIES #####

var scale: float = 1.0
var popup_add: PopupMenu = null
var press_a_key: PressAKey = null
var device_input: DeviceInput = null

var add_at: String = ""
var edit_idx: int = 0
var add_type: int = 0

var setting: bool = false

##### CONSTRUCTORS #####

func _init():
	set_v_size_flags(SIZE_EXPAND_FILL)
	set_h_size_flags(SIZE_EXPAND_FILL)
	set_columns(Column.MAX)
	set_column_titles_visible(true)
	set_column_title(Column.ACTION, tr("Action"))
	set_column_title(Column.DEADZONE, tr("Deadzone"))
	set_column_expand(Column.DEADZONE, false)
	set_column_min_width(Column.DEADZONE, 80 * scale)
	set_column_expand(Column.OPTIONS, false)
	set_column_min_width(Column.OPTIONS, 50 * scale)
	connect("item_edited", self, "_action_edited")
	connect("item_activated", self, "_action_activated")
	connect("cell_selected", self, "_action_selected")
	connect("button_pressed", self, "_action_button_pressed")

	popup_add = PopupMenu.new()
	add_child(popup_add)
	popup_add.connect("id_pressed", self, "_add_item")

	press_a_key = PressAKey.new()
	add_child(press_a_key)
	device_input = DeviceInput.new()
	add_child(device_input)

##### PRIVATE METHODS #####

func _device_input_add():
	var ie: InputEvent
	var name: String = add_at
	var idx: int = edit_idx
	var old_val: Dictionary = ProjectSettings.get_setting(name)
	var action: Dictionary = old_val.duplicate()
	var events: Array = action["events"]
	
	match add_type:
		InputType.INPUT_MOUSE_BUTTON:
			var mb := InputEventMouseButton.new();
			mb.button_index = device_input.device_index.selected + 1
			mb.device = device_input.get_current_device()
			
			for i in range(events.size()):
				var aie: InputEventMouseButton = events[i]
				if not aie:
					continue
				if aie.device == mb.device and aie.button_index == mb.button_index:
					return
			ie = mb
		
		InputType.INPUT_JOY_MOTION:
			
			var jm := InputEventJoypadMotion.new()
			jm.axis = device_input.get_selected_device_index() >> 1
			jm.axis_value = 1 if device_input.get_selected_device_index() & 1 else -1
			jm.device = device_input.get_current_device()
			
			for i in range(events.size()):
				var aie: InputEventJoypadMotion = events[i]
				if not aie:
					continue
				if aie.device == jm.device and aie.axis == jm.axis and aie.axis_value == jm.axis_value:
					return
			ie = jm
		
		InputType.INPUT_JOY_BUTTON:
			
			var jb := InputEventJoypadButton.new()
			jb.button_index = device_input.get_selected_device_index()
			jb.device = device_input.get_current_device()
			
			for i in range(events.size()):
				var aie: InputEventJoypadButton = events[i]
				if not aie:
					continue
				if aie.device == jb.device and aie.button_index == jb.button_index:
					return
			ie = jb
	
	if idx < 0 or idx >= events.size():
		events.push_back(ie)
	else:
		events[idx] = ie
	action["events"] = events
	
	var ur = App.undo_redo
	ur.create_action(tr("Add Input Action Event"));
	ur.add_do_method(ProjectSettings, "set", name, action);
	ur.add_undo_method(ProjectSettings, "set", name, old_val);
	ur.add_do_method(self, "_update_actions");
	ur.add_undo_method(self, "_update_actions");
	ur.add_do_method(self, "_settings_changed");
	ur.add_undo_method(self, "_settings_changed");
	ur.commit_action();

	emit_signal("input_action_event_added", ie, name)

func _validate_action_name(p_name: String) -> bool:
	return true

##### CONNECTIONS #####

func _action_edited():
	var ti: TreeItem = get_selected()
	if not ti:
		return
	match get_selected_column():
		Column.ACTION:
			var new_name := ti.get_text(0)
			var old_name := add_at.substr(add_at.find("/") + 1, add_at.length())
			
			if new_name == old_name:
				return
			
			if not new_name or not _validate_action_name(new_name):
				ti.set_text(0, old_name)
				add_at = "input/" + old_name
				
				var message = tr("Invalid action name. It cannot be empty or contain '/', ':', '=', '\\', or '\"'")
				emit_signal("error_occurred", message)
				return
			
			var action_prop: String = "input/" + new_name
			
			if ProjectSettings.has_setting(action_prop):
				ti.set_text(0, old_name)
				add_at = "input/" + old_name
				
				var message = tr("Action '%s' already exists!" % [new_name])
				emit_signal("error_occurred", message)
				return
			
			var order: int = ProjectSettings.get_order(add_at)
			var action: Dictionary = ProjectSettings.get(add_at)
			
			setting = true
			var ur = App.undo_redo
			ur.create_action(tr("Rename Input Action Event"))
			ur.add_do_method(ProjectSettings, "clear", add_at)
			ur.add_do_method(ProjectSettings, "set", action_prop, action)
			ur.add_do_method(ProjectSettings, "set_order", action_prop, order)
			ur.add_undo_method(ProjectSettings, "clear", action_prop)
			ur.add_undo_method(ProjectSettings, "set", add_at, action)
			ur.add_undo_method(ProjectSettings, "set_order", add_at, order)
			ur.add_do_method(self, "_update_actions")
			ur.add_undo_method(self, "_update_actions")
			ur.add_do_method(self, "_settings_changed")
			ur.add_undo_method(self, "_settings_changed")
			ur.commit_action()
			setting = false
				
			add_at = action_prop
		Column.DEADZONE:

			var name: String = "input/" + ti.get_text(0)
			var old_action: Dictionary = ProjectSettings.get(name)
			var new_action: Dictionary = old_action.duplicate()
			new_action["deadzone"] = ti.get_range(1)

			var ur = App.undo_redo
			ur.create_action(tr("Change Action deadzone"))
			ur.add_do_method(ProjectSettings, "set", name, new_action)
			ur.add_do_method(self, "_settings_changed")
			ur.add_undo_method(ProjectSettings, "set", name, old_action)
			ur.add_undo_method(self, "_settings_changed")
			ur.commit_action()

func _action_activated():
	pass

func _action_selected():
	var ti: TreeItem = get_selected()
	if not ti or not ti.is_editable(0):
		return
	add_at = "input/" + ti.get_text(0)
	edit_idx = -1

func _action_button_pressed(p_item: TreeItem, p_column: int, p_id: int):
	pass

func _add_item(p_id: int):
	pass

##### SETTERS AND GETTERS #####
