extends Control


# Graph format: {vertexobj:[vertexname, [{lineobj1:0}, {lineobj2:1}]}
# Where the value 0 means the point 0 of the line (the origin) is in that node,
# and the value 1 means the point 1 of the line (the end) is in that node.
# It is necessary to save this data so, when moving the nodes around, we know
# which points of the Line2Ds to change.
var graph: Dictionary = {}


const MODE_DRAW_VERTICES: int = 0
const MODE_DRAW_EDGES: int = 1
const MODE_EDIT: int = 2
const MODE_DELETE: int = 3

var current_mode: int
var previous_mode: int

var mouse_over_vertex: Node2D = null

var current_line: Line2D

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
	
	if current_line != null:
		current_line.set_point_position(1, get_global_mouse_position())


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
			
			if current_mode == MODE_DRAW_VERTICES && mouse_over_vertex == null:
				draw_vertex(get_global_mouse_position())
			
			if mouse_over_vertex != null:
				if current_line == null:
					current_line = Line2D.new()
					$Instances/Edges.add_child(current_line)
					current_line.width = 8
					current_line.add_point(mouse_over_vertex.global_position)
					# This second point will be changed every physics tic.
					current_line.add_point(get_global_mouse_position())
				
				else:
					current_line.set_point_position(1, mouse_over_vertex.position)
					current_line = null


func _on_mouse_follower_area_entered(area: Area2D):
	if area.get_parent() in $Instances/Vertices.get_children(false):
		mouse_over_vertex = area.get_parent();


func _on_mouse_follower_area_exited(area):
	if area.get_parent() in $Instances/Vertices.get_children(false):
		mouse_over_vertex = null;
