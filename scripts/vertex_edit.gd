extends Window

var vertex: Node2D


func _ready():
	$Panel/LineEdit.grab_focus()


func _input(event):
	if event.is_action_pressed("custom_ui_accept"):
		_on_apply_button_pressed()


func set_vertex(vertex_input: Node2D):
	vertex = vertex_input
	$Panel/Title.text = $Panel/Title.text + " (" + vertex.name + ")"


func _on_apply_button_pressed():
	var text: String = $Panel/LineEdit.text
	var new_name: String = text.replace(" ", "")
	
	if new_name != "":
		vertex.name = new_name
		vertex.set_vertex_name(new_name)
	
	hide()


func _on_cancel_button_pressed():
	hide()
