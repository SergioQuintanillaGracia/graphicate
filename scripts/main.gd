extends Control


# Graph format: {vertexobj:[[lineobj1, 0], [lineobj2, 1]}
# Where the value 0 means the point 0 of the line (the origin) is in that node,
# and the value 1 means the point 1 of the line (the end) is in that node.
# It is necessary to save this data so, when moving the nodes around, we know
# which points of the Line2Ds to change.
var graph: Dictionary = {}

var vertex_name_count: int = 0

const MODE_DRAW_VERTICES: int = 0
const MODE_DRAW_EDGES: int = 1
const MODE_EDIT: int = 2
const MODE_DELETE: int = 3

var current_mode: int
var previous_mode: int

var mouse_over_vertex: Node2D = null
var mouse_over_edge: Line2D = null

var current_line: Line2D
# Needed to remove the line data from the graph
# in case esc is pressed while creating the edge
var current_line_vertex: Node2D
var current_line_vertex_end: Node2D

var vertex_scene: PackedScene = load("res://scenes/vertex.tscn")
var edge_scene: PackedScene = load("res://scenes/edge.tscn")
var vertex_edit: PackedScene = load("res://scenes/vertex_edit.tscn")
var edge_edit: PackedScene = load("res://scenes/edge_edit.tscn")


func _ready():
	current_mode = -1
	previous_mode = -1
	update_selected_button()


func _physics_process(_delta):
	$MouseCollisionArea.position = get_global_mouse_position()

	if current_line != null:
		current_line.set_point_position(1, get_global_mouse_position())


func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		if current_line != null:
			# We need to delete the line data from the graph.
			cancel_line()
	
	if Input.is_action_just_pressed("print_graph_to_console"):
		print(get_graph_string())
	
	if Input.is_action_just_pressed("draw_vertex_mode"):
		set_current_mode(MODE_DRAW_VERTICES)

	if Input.is_action_just_pressed("draw_edge_mode"):
		set_current_mode(MODE_DRAW_EDGES)
	
	if Input.is_action_just_pressed("edit_mode"):
		set_current_mode(MODE_EDIT)
	
	if Input.is_action_just_pressed("delete_mode"):
		set_current_mode(MODE_DELETE)
	
	if Input.is_action_just_pressed("toggle_menu"):
		$HBoxContainer/Sidebar/VBoxContainer/TopContainer/ToggleButton.play_animation()


func cancel_line():
	graph[current_line_vertex].erase([current_line, 0])
	current_line.queue_free()
	update_degree(current_line_vertex)
	
	if current_line_vertex_end != null:
		update_degree(current_line_vertex_end)
	
	current_line = null
	current_line_vertex = null
	current_line_vertex_end = null


func get_graph_string():
	var string: String = "{"
	
	for i in graph:
		string += i.name
		string += ":["
		
		for j in graph[i]:
			string += "["
			string += "Line," + str(j[1])
			string += "],"
		
		string += "],"
	
	string += "}"
	
	return string


func are_adjacent(v1: Node2D, v2: Node2D):
	# v1 and v2 will be adjacent if a line starts in v1, and the same line ends
	# in v2, or the opposite.
	
	for line_list_1 in graph[v1]:
		var line_1: Node2D = line_list_1[0]
		var line_1_val: int = line_list_1[1]
		
		for line_list_2 in graph[v2]:
			var line_2: Node2D = line_list_2[0]
			var line_2_val: int = line_list_2[1]
			
			if line_1 == line_2:
				if (line_1_val == 0 and line_2_val == 1) or (line_1_val == 1 and line_2_val == 0):
					return true
	
	return false


func update_selected_button():
	for i in $HBoxContainer/Sidebar/VBoxContainer/TopContainer.get_children(false):
		var node: Control = i
		
		if current_mode != previous_mode && "ButtonIdentifier" in node.get_meta_list():
			if node.get_meta("ButtonIdentifier") == current_mode:
				node.get_node("ColorRect").color = "3d3d42"
			
			elif node.get_meta("ButtonIdentifier") == previous_mode:
				node.get_node("ColorRect").color = "2e2e2e"


func set_current_mode(new_mode: int):
	previous_mode = current_mode
	current_mode = new_mode
	update_selected_button()


func draw_vertex(position: Vector2, name: String):
	if name == "":
		name = "v" + str(vertex_name_count)
		vertex_name_count += 1
	
	var vertex_instance: Node2D = vertex_scene.instantiate()
	vertex_instance.name = name
	vertex_instance.set_vertex_name(name)
	$Instances/Vertices.add_child(vertex_instance)
	vertex_instance.position = position
	graph[vertex_instance] = []


func _on_draw_vertex_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 && event.is_pressed():
			set_current_mode(MODE_DRAW_VERTICES)


func _on_draw_edge_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 && event.is_pressed():
			set_current_mode(MODE_DRAW_EDGES)


func _on_edit_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 && event.is_pressed():
			set_current_mode(MODE_EDIT)


func _on_delete_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 && event.is_pressed():
			set_current_mode(MODE_DELETE)


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
			update_mouse_overlapping_areas()
			
			if current_mode == MODE_DRAW_VERTICES && mouse_over_vertex == null:
				# We need to draw a vertex.
				draw_vertex(get_global_mouse_position(), "")
			
			if current_mode == MODE_DRAW_EDGES && mouse_over_vertex != null:
				# We need to draw a line.
				if current_line == null:
					# The line should start at this vertex.
					current_line = edge_scene.instantiate()
					$Instances/Edges.add_child(current_line)
					
					current_line.add_point(mouse_over_vertex.global_position)
					# This second point will be changed every physics tic.
					current_line.add_point(get_global_mouse_position())
					
					current_line_vertex = mouse_over_vertex
					
					# Add the line data to the graph.
					graph[current_line_vertex].append([current_line, 0])
					
					update_degree(current_line_vertex)
				
				else:
					# The line should end at this vertex.
					current_line.set_point_position(1, mouse_over_vertex.position)
					
					current_line_vertex_end = mouse_over_vertex
					
					# If the nodes are already adjacent, cancel the line.
					if are_adjacent(current_line_vertex, current_line_vertex_end):
						cancel_line()
					
					# If the destination node is the same as the origin node,
					# cancel the line.
					elif (current_line_vertex == current_line_vertex_end):
						cancel_line()
					
					else:
						# Add the line data to the graph.
						graph[current_line_vertex_end].append([current_line, 1])
						
						update_degree(current_line_vertex_end)
						
						# Create the CollisionShape for the line, so we can interact
						# with it.
						current_line.create_collisionshape()
						
						current_line.set_weight(0)
						
						current_line = null
						current_line_vertex = null
						current_line_vertex_end = null
			
			if current_mode == MODE_DELETE:
				if mouse_over_vertex != null:
					# We will store the edges to clear in an array.
					var edges_to_clear: Array
					
					# We get the edges we need to clear.
					for edge_list in graph[mouse_over_vertex]:
						edges_to_clear.append(edge_list[0])
						edge_list[0].queue_free()
					
					mouse_over_vertex.queue_free()
					
					graph.erase(mouse_over_vertex)
					
					# Erase the lines we need to clear from every vertex theym were connected to
					for vertex in graph:
						for edge_list in graph[vertex]:
							if edge_list[0] in edges_to_clear:
								var edge_state = edge_list[1]
								edge_list[0].queue_free()
								
								graph[vertex].erase([edge_list[0], edge_state])
								
								update_degree(vertex)
				
				elif mouse_over_edge != null:
					# Erase the line data from every vertex it is in.
					for vertex in graph:
						for edge_list in graph[vertex]:
							if edge_list[0] == mouse_over_edge:
								var edge_state = edge_list[1]
								graph[vertex].erase([edge_list[0], edge_state])
								
								update_degree(vertex)
					
					mouse_over_edge.queue_free()
			
			if current_mode == MODE_EDIT:
				if mouse_over_vertex != null:
					# Instantiate the vertex edit popup
					var vertex_edit_popup = vertex_edit.instantiate()
					add_child(vertex_edit_popup)
					vertex_edit_popup.position = get_viewport_rect().size / 2
					vertex_edit_popup.position.x -= vertex_edit_popup.size.x / 2
					vertex_edit_popup.position.y -= vertex_edit_popup.size.y / 2
					
					vertex_edit_popup.set_vertex(mouse_over_vertex)
				
				elif mouse_over_edge != null:
					# Instantiate the edge edit popup
					var edge_edit_popup = edge_edit.instantiate()
					add_child(edge_edit_popup)
					edge_edit_popup.position = get_viewport_rect().size / 2
					edge_edit_popup.position.x -= edge_edit_popup.size.x / 2
					edge_edit_popup.position.y -= edge_edit_popup.size.y / 2
					
					edge_edit_popup.set_edge(mouse_over_edge)


func update_degree(vertex: Node2D):
	vertex.set_degree(graph[vertex].size())


func update_mouse_overlapping_areas():
	for area in $MouseCollisionArea.get_overlapping_areas():
		if area.get_parent() in $Instances/Vertices.get_children(false):
			mouse_over_vertex = area.get_parent();
		if area.get_parent() in $Instances/Edges.get_children(false):
			mouse_over_edge = area.get_parent();


func _on_mouse_collision_area_area_exited(area):
	if area.get_parent() in $Instances/Vertices.get_children(false):
		mouse_over_vertex = null;
	if area.get_parent() in $Instances/Edges.get_children(false):
		mouse_over_edge = null;
