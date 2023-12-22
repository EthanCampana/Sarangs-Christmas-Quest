extends PlayerState
class_name Death


# Defines what happens when the state is entered
func Enter():
	player.animation_player.current_animation = "Die"


# Defines what happens when the state is exited
func Exit():
	pass
