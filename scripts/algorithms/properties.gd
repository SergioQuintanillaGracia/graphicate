extends Node2D

# mess_man comes from message_manager
@onready var mess_man: Node2D = $"../MessageManager"


func start(graph: Dictionary):
	$"../../HBoxContainer/Algorithms/TabContainer".current_tab = 1
	show_properties(graph)


func show_properties(graph: Dictionary):
	var vertex_count: int = graph.size()
	var edges: Array
	
	for vertex in graph:
		for edge_list in graph[vertex]:
			var edge: Node2D = edge_list[0]
			
			if edge not in edges:
				edges.append(edge)
	
	mess_man.add_message(mess_man.ICON_INFO, "Vertices: " + str(graph.size()))
	mess_man.add_message(mess_man.ICON_INFO, "Edges: " + str(edges.size()))
