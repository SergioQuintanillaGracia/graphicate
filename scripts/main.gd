extends Control


const MODE_DRAW_VERTICES: int = 0
const MODE_DRAW_EDGES: int = 1
const MODE_EDIT: int = 2
const MODE_DELETE: int = 3

var current_mode: int
var previous_mode: int

var is_mouse_over_vertex: bool = false

var vertex_scene: PackedScene = load("res://scenes/vertex.tscn")


func _ready():
	current_mode = -1
	previous_mode = -1
	update_selected_button()


func _process(_delta):
	pass


func update_selected_button():
	for i in $HBoxContainer/Sidebar/VBoxContainer/TopContainer.get_children(false):
		var node: Control = i
		
		if current_mode != previous_mode && "ButtonIdentifier" in node.get_meta_list():
			if node.get_meta("ButtonIdentifier") == current_mode:
				node.get_node("Icon").position[0] += 20
			
			elif node.get_meta("ButtonIdentifier") == previous_mode:
				node.get_node("Icon").position[0] -= 20


func _physics_process(_delta):
	$MouseFollower.position = get_global_mouse_position()


func draw_vertex(position: Vector2):
	var vertex_instance: Node2D = vertex_scene.instantiate()
	$Instances/Vertices.add_child(vertex_instance)
	vertex_instance.position = position


func _on_draw_vertex_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 && event.is_pressed():
			previous_mode = current_mode
			current_mode = MODE_DRAW_VERTICES
			print("Changed mode to " + str(current_mode))
			
			update_selected_button()


func _on_draw_edge_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 && event.is_pressed():
			previous_mode = current_mode
			current_mode = MODE_DRAW_EDGES
			print("Changed mode to " + str(current_mode))
			
			update_selected_button()


func _on_edit_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 && event.is_pressed():
			previous_mode = current_mode
			current_mode = MODE_EDIT
			print("Changed mode to " + str(current_mode))
			
			update_selected_button()


func _on_delete_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 && event.is_pressed():
			previous_mode = current_mode
			current_mode = MODE_DELETE
			print("Changed mode to " + str(current_mode))
			
			update_selected_button()


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
			
			if current_mode == MODE_DRAW_VERTICES && !is_mouse_over_vertex:
				draw_vertex(get_global_mouse_position())


func _on_mouse_follower_area_entered(area: Area2D):
	if area.get_parent() in $Instances/Vertices.get_children(false):
		is_mouse_over_vertex = true;
	


func _on_mouse_follower_area_exited(area):
	if area.get_parent() in $Instances/Vertices.get_children(false):
		is_mouse_over_vertex = false;
