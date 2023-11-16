extends Node2D

@onready var message_manager: Node2D = $"../MessageManager"


func start(graph: Dictionary):
	$"../../HBoxContainer/Algorithms/TabContainer".current_tab = 1
	show_properties(graph)


func show_properties(graph: Dictionary):
	var vertex_count: int = graph.size()
	
	message_manager.add_message(message_manager.ICON_INFO, "Information")
	message_manager.add_message(message_manager.ICON_TICK, "Success")
	message_manager.add_message(message_manager.ICON_CROSS, "Error")
	message_manager.add_message(message_manager.ICON_UNKNOWN, "Unknown")
