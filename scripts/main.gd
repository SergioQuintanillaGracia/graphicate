extends Control


const MODE_DRAW_VERTICES: int = 0
const MODE_DRAW_EDGES: int = 1
const MODE_EDIT: int = 2
const MODE_DELETE: int = 3

var current_mode: int


func _ready():
	current_mode = MODE_DRAW_VERTICES


func _process(_delta):
	pass


func _on_draw_vertex_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 && event.is_pressed():
			current_mode = MODE_DRAW_VERTICES
			print("Changed mode to " + str(current_mode))


func _on_draw_edge_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 && event.is_pressed():
			current_mode = MODE_DRAW_EDGES
			print("Changed mode to " + str(current_mode))


func _on_edit_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 && event.is_pressed():
			current_mode = MODE_EDIT
			print("Changed mode to " + str(current_mode))


func _on_delete_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 && event.is_pressed():
			current_mode = MODE_DELETE
			print("Changed mode to " + str(current_mode))


func _on_image_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 && event.is_pressed():
			print("Image button pressed")

func _on_settings_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 && event.is_pressed():
			print("Settings button pressed")


func _on_panel_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 && event.is_pressed():
			print("Mouse click pressed on drawing space")
