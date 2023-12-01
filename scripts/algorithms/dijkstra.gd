extends Node2D

# mess_man comes from message_manager
@onready var mess_man: Node2D = $"../MessageManager"

var graph: Dictionary = {}
var is_next_step: bool = false


func _process(_delta):
	if is_next_step:
		# When next(graph) is run, the next step is run. If it returns false,
		# it means there is no next step.
		is_next_step = next(graph)
		
		print("Dijkstra ran a step.")
		
		pass


func start(graph_input: Dictionary):
	$"../../HBoxContainer/Algorithms/TabContainer".current_tab = 1
	graph = graph_input
	is_next_step = next(graph)


func next(graph: Dictionary) -> bool:
	# Returns true if there is a next step.
	for vertex in graph:
		for edge in graph[vertex]:
			if edge.get_weight() == 0:
				# There is at least an edge that doesn't have weight.
				mess_man.add_message(mess_man.ICON_CROSS, "Not all edges\nhave weights")
				return false
	
	return true
