extends Control
@onready var animation_player = $MarginContainer/VBoxContainer/AnimationPlayer

var scene_changing = false
func _ready():
	set_process_input(true)
	start_fading_animation()
	
	
func _input(event):
	if event is InputEventKey and not scene_changing:
		scene_changing = true
	

func start_fading_animation():
	if animation_player.has_animation("fadeLoop"):
		animation_player.play("fadeLoop")



func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fadeLoop":
		if scene_changing:
			get_tree().change_scene_to_file("res://scenes/Level_1.tscn")
		else:
			start_fading_animation()
