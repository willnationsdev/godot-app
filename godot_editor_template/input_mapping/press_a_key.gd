# author: willnationsdev
# license: MIT
# description: 
# imports: 
tool
extends ConfirmationDialog
class_name PressAKey

##### CLASSES #####

##### SIGNALS #####

##### CONSTANTS #####

##### PROPERTIES #####

var label: Label = null
var last_wait_for_key: InputEvent = null

##### NOTIFICATIONS #####

func _init():
	set_focus_mode(FOCUS_ALL)

	label = Label.new()
	label.text = tr("Press a Key...")
	label.set_anchors_and_margins_preset(Control.PRESET_WIDE)
	label.align = Label.ALIGN_CENTER
	label.margin_top = 20
	label.set_anchor_and_margin(MARGIN_BOTTOM, Control.ANCHOR_BEGIN, 30)
	add_child(label)
	connect("gui_input", self, "_wait_for_key")
	connect("confirmed", self, "_press_a_key_confirm")
    
##### OVERRIDES #####

##### VIRTUALS #####

##### PUBLIC METHODS #####

##### CONNECTIONS #####

func _wait_for_key(p_event: InputEvent):
	
	var k: InputEventKey = p_event as InputEventKey
	
	if k and k.pressed and k.scancode != 0:
		last_wait_for_key = p_event
		
		label.text = OS.get_scancode_string(k.scancode)
		accept_event()

func _press_a_key_confirm():
	pass

##### PRIVATE METHODS #####

##### SETTERS AND GETTERS #####