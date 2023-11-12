extends Control

var anim_player

func _ready():
	anim_player = $"../../../../../AnimationPlayer"

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 && event.is_pressed():
			play_animation()


func play_animation():
	if $"../../..".custom_minimum_size[0] <= 120:
		anim_player.play("SidebarAnimation")
		
	else:
		anim_player.play_backwards("SidebarAnimation")
