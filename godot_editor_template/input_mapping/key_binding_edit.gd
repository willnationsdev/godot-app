# author: willnationsdev
# license: MIT
# description: 
# imports: 
extends HBoxContainer
class_name KeyBindingEdit

##### CLASSES #####

##### SIGNALS #####

signal key_binding_remapped(old_key, new_key)

##### CONSTANTS #####

##### PROPERTIES #####

export var action: String = "" setget set_action
export var input: InputEventKey = null setget set_input

var label: Label = null
var button: Button = null

##### NOTIFICATIONS #####

func _init():
    label = Label.new()

##### OVERRIDES #####

##### VIRTUALS #####

##### PUBLIC METHODS #####

##### PRIVATE METHODS #####

##### CONNECTIONS #####

##### SETTERS AND GETTERS #####

func set_action(p_value: String):
    text = p_value
    if label:
        label.text = text

func set_input(p_value: InputEventKey):
    input = p_value
    if input and button:
        button.text = OS.get_scancode_string(input.scancode)