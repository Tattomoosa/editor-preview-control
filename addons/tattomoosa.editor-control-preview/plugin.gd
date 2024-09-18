@tool
extends EditorPlugin

var bottom_panel_control := preload("./src/editor_control_preview.tscn").instantiate()

func _enter_tree():
	# Initialization of the plugin goes here.
	bottom_panel_control.editor_interface = get_editor_interface()
	add_control_to_bottom_panel(bottom_panel_control, "Control Preview")
	pass


func _exit_tree():
	remove_control_from_bottom_panel(bottom_panel_control)
	pass
