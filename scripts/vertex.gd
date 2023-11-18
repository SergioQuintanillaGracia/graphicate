extends Node2D

var degree: int = 0

func set_vertex_name(name: String) -> void:	
	$Name.text = name


func get_vertex_name() -> String:
	return $Name.text


func get_degree() -> int:
	return degree


func set_degree(new_degree: int) -> void:
	degree = new_degree
	$Degree.text = str(degree) if degree < 10 else "+"
