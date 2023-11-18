extends Control

var unknown_icon: CompressedTexture2D = load("res://icons/algorithms/unknown_icon.png")
var tick_icon: CompressedTexture2D = load("res://icons/menus/tick_icon.png")
var cross_icon: CompressedTexture2D = load("res://icons/algorithms/cross_icon.png")
var info_icon: CompressedTexture2D = load("res://icons/algorithms/info_icon.png")

# These variables are also defined in message_manager
var ICON_UNKNOWN: int = 0
var ICON_TICK: int = 1
var ICON_CROSS: int = 2
var ICON_INFO: int = 3

func get_panel_size() -> Vector2:
	return $Panel.size;


func set_text(new_text: String) -> void:
	$Panel/Label.text = new_text
	
	# Each text line increases the label size by 25, so we need
	# to make the panel bigger.
	# 6 is the separation between the label and the top / bottom edges
	# of the panel.
	var extra_size: Vector2 = Vector2(0, new_text.count("\n") * 25 - 6)
	# If there is only one line, the extra size will be negative, so set
	# it to 0.
	extra_size = extra_size if extra_size > Vector2(0, 0) else Vector2(0, 0)
	
	$Panel.set_size($Panel.size + extra_size)
	custom_minimum_size += extra_size
	$Panel/Icon.position += extra_size / 2


func set_icon(icon_type: int) -> void:
	if icon_type == ICON_UNKNOWN:
		$Panel/Icon.texture = unknown_icon
	elif icon_type == ICON_TICK:
		$Panel/Icon.texture = tick_icon
	elif icon_type == ICON_CROSS:
		$Panel/Icon.texture = cross_icon
	elif icon_type == ICON_INFO:
		$Panel/Icon.texture = info_icon
	else:
		print("Could not set icon of type " + str(icon_type)
		+ ". The type should be 1, 2, or 3")
