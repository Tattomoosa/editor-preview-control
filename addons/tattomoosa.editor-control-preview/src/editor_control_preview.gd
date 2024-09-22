@tool
extends Control

@onready var load_selected_control_button : Button = %LoadSelectedControlButton
@onready var load_edited_scene_root_button : Button = %LoadEditedSceneRootButton
@onready var clear_button : Button = %ClearButton
@onready var root : Control = %Root

var editor_interface : EditorInterface

func _ready():
	load_selected_control_button.disabled = editor_interface == null
	load_selected_control_button.icon = get_theme_icon("ToolSelect", "EditorIcons")
	load_selected_control_button.pressed.connect(_load_selected_control)
	load_edited_scene_root_button.pressed.connect(_load_scene_root)
	load_edited_scene_root_button.icon = get_theme_icon("PackedScene", "EditorIcons")
	clear_button.pressed.connect(_clear)

	editor_interface.get_selection().selection_changed.connect(
		func():
			if editor_interface.get_selection().get_selected_nodes().is_empty():
				load_selected_control_button.disabled = true
			else:
				load_selected_control_button.disabled = false
	)

func _clear():
	for child in root.get_children(true):
		remove_child(child)
		child.queue_free()

func _load_selected_control():
	_clear()
	var selected := editor_interface.get_selection().get_selected_nodes()
	if selected.size() > 1:
		push_warning("Previewing multiple nodes may have unintended consequences")
	for node in selected:
		_add_node(node)

func _load_scene_root():
	_clear()
	var scene_root := editor_interface.get_edited_scene_root()
	_add_node(scene_root)

func _add_node(node: Node):
	node = node.duplicate()
	node.set("editor_interface", editor_interface)
	root.add_child(node)
