@tool
extends Control

@onready var load_selected_control_button : Button = %LoadSelectedControlButton
@onready var load_edited_scene_root_button : Button = %LoadEditedSceneRootButton
@onready var clear_button : Button = %ClearButton
@onready var root : Control = %Root

const DUPLICATE_FLAGS = DuplicateFlags.DUPLICATE_USE_INSTANTIATION | DuplicateFlags.DUPLICATE_SCRIPTS

@warning_ignore("return_value_discarded")
func _ready() -> void:
	load_selected_control_button.disabled = EditorInterface == null
	load_selected_control_button.icon = get_theme_icon("ToolSelect", "EditorIcons")
	load_selected_control_button.pressed.connect(_load_selected_control)
	load_edited_scene_root_button.pressed.connect(_load_scene_root)
	load_edited_scene_root_button.icon = get_theme_icon("PackedScene", "EditorIcons")
	clear_button.pressed.connect(_clear)

	EditorInterface.get_selection().selection_changed.connect(_on_selection_changed)

func _on_selection_changed() -> void:
	if EditorInterface.get_selection().get_selected_nodes().is_empty():
		load_selected_control_button.disabled = true
	else:
		load_selected_control_button.disabled = false

func _clear() -> void:
	for child in root.get_children(true):
		root.remove_child(child)
		child.queue_free()

func _load_selected_control() -> void:
	_clear()
	var selected := EditorInterface.get_selection().get_selected_nodes()
	if selected.size() > 1:
		push_warning("Previewing multiple nodes may have unintended consequences")
	for node in selected:
		_add_node(node)

func _load_scene_root() -> void:
	_clear()
	var scene_root := EditorInterface.get_edited_scene_root()
	_add_node(scene_root)

func _add_node(node: Node) -> void:
	node = node.duplicate(DUPLICATE_FLAGS)
	root.add_child(node)
