@tool
extends Control

@onready var load_selected_control_button : Button = %LoadSelectedControlButton
@onready var root : Control = %Root

var editor_interface : EditorInterface
	# set(value):
	# 	editor_interface = value
	# 	if is_instance_valid(load_selected_control_button):
	# 		load_selected_control_button.disabled = value == null

func _ready():
	print(editor_interface)
	load_selected_control_button.disabled = editor_interface == null
	load_selected_control_button.pressed.connect(_load_selected_control)

func _load_selected_control():
	for child in root.get_children(true):
		remove_child(child)
		child.queue_free()
	
	var selected := editor_interface.get_selection().get_selected_nodes()
	if selected.size() > 1:
		push_warning("Previewing multiple nodes may have unintended consequences")
	for node in selected:
		root.add_child(node.duplicate())