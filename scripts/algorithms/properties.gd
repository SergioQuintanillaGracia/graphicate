extends Node2D

# mess_man comes from message_manager
@onready var mess_man: Node2D = $"../MessageManager"


func start(graph: Dictionary):
	$"../../HBoxContainer/Algorithms/TabContainer".current_tab = 1
	show_properties(graph)


func show_properties(graph: Dictionary):
	var vertex_count: int = graph.size()
	var edges: Array
	var total_weight: float = 0
	var total_degree: int = 0
	
	for vertex in graph:
		total_degree += vertex.get_degree()
		
		for edge in graph[vertex]:
			total_weight += edge.get_weight()
			
			if edge not in edges:
				edges.append(edge)
	
	# We have to divide the total weight by 2 because each edge's weight
	# will be added twice (as each edge is in 2 vertices)
	total_weight /= 2
	
	mess_man.add_message(mess_man.ICON_INFO, "Vertices: " + str(graph.size()))
	mess_man.add_message(mess_man.ICON_INFO, "Edges: " + str(edges.size()))
	mess_man.add_message(mess_man.ICON_INFO, "Total degree:\n" + str(total_degree))
	mess_man.add_message(mess_man.ICON_INFO, "Total weight:\n" + str(total_weight))
