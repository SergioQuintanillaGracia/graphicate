extends Line2D

var weight = 0

var p1: Vector2
var p2: Vector2

var initial_vertex: Node2D = null
var final_vertex: Node2D = null

func create_collisionshape() -> void:
	p1 = get_point_position(0)
	p2 = get_point_position(1)
	$Area2D/CollisionShape2D.position = (p1 + p2) / 2
	$Area2D/CollisionShape2D.rotation = p1.direction_to(p2).angle()
	
	var shape: RectangleShape2D = RectangleShape2D.new()
	var dist: float = p1.distance_to(p2)
	shape.size = Vector2(dist, width + 8)
	$Area2D/CollisionShape2D.shape = shape
	
	update_label_position()


func update_label_position() -> void:
	$Label.position = (p1 + p2) / 2
	$Label.position[0] -= $Label.size.x / 2
	$Label.position[1] -= $Label.size.y / 2


func set_vertices(i_vertex: Node2D, f_vertex: Node2D) -> void:
	initial_vertex = i_vertex
	final_vertex = f_vertex


func set_initial_vertex(vertex: Node2D) -> void:
	initial_vertex = vertex


func set_final_vertex(vertex: Node2D) -> void:
	final_vertex = vertex


func get_initial_vertex() -> Node2D:
	return initial_vertex


func get_final_vertex() -> Node2D:
	return final_vertex


func get_weight() -> float:
	return weight


func set_weight(new_weight: float) -> void:
	weight = new_weight
	if weight == 0:
		$Label.text = ""
	else:
		$Label.text = str(weight)
