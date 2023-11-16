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

func set_icon(icon_type: int) -> void:
	if icon_type == ICON_UNKNOWN:
		$Panel/Sprite2D.texture = unknown_icon
	elif icon_type == ICON_TICK:
		$Panel/Sprite2D.texture = tick_icon
	elif icon_type == ICON_CROSS:
		$Panel/Sprite2D.texture = cross_icon
	elif icon_type == ICON_INFO:
		$Panel/Sprite2D.texture = info_icon
	else:
		print("Could not set icon of type " + str(icon_type)
		+ ". The type should be 1, 2, or 3")
