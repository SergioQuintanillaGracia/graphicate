extends Node2D

var message: PackedScene = load("res://scenes/algorithm_message.tscn")
var messages: Array
var offset_x: int = 10
var offset_y: int = 10

# These variables are also defined inside algorithm_message
var ICON_UNKNOWN: int = 0
var ICON_TICK: int = 1
var ICON_CROSS: int = 2
var ICON_INFO: int = 3

var latest_message_instance: Control = null

@onready var tab: VBoxContainer = $"../../HBoxContainer/Algorithms/TabContainer/Current/VBoxContainer"

func add_message(icon_type: int, text: String):
	var message_instance: Control = message.instantiate()
	message_instance.set_icon(icon_type)
	message_instance.set_text(text)
	
	tab.add_child(message_instance)
	
	latest_message_instance = message_instance
