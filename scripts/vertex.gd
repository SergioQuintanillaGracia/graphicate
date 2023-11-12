extends Node2D


func set_vertex_name(name: String) -> void:	
	$Name.text = name

func get_vertex_name() -> String:
	return $Name.text

func set_degree(degree: int) -> void:
	$Degree.text = str(degree) if degree < 10 else "+"
