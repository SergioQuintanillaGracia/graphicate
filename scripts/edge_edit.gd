extends Popup

var edge: Node2D


func _ready():
	$Panel/LineEdit.grab_focus()


func _input(event):
	if event.is_action_pressed("custom_ui_accept"):
		_on_apply_button_pressed()


func set_edge(edge_input: Node2D):
	edge = edge_input


func _on_apply_button_pressed():
	var text: String = $Panel/LineEdit.text
	var new_weight: float = float(text.replace(" ", "").replace(",", "."))
	
	if (text == "0"):
		# When the conversion isn't successfully carried out, it float() returns
		# 0, that's why we need to handle the case "0" independently.
		edge.set_weight(new_weight)
	
	if (new_weight > 0):
		edge.set_weight(new_weight)
	
	hide()


func _on_cancel_button_pressed():
	hide()
