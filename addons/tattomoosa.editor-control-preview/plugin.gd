@tool
extends EditorPlugin

var bottom_panel_control := preload("./src/editor_control_preview.tscn").instantiate()

@warning_ignore("return_value_discarded")
func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_control_to_bottom_panel(bottom_panel_control, "Control Preview")


func _exit_tree() -> void:
	remove_control_from_bottom_panel(bottom_panel_control)
