extends Window

# This should be set to the graph dictionary when summoning the window.
var graph: Dictionary = {}


func set_graph(graph_input: Dictionary):
	graph = graph_input


func _on_apply_button_pressed():
	$"../Dijkstra".start(graph)
