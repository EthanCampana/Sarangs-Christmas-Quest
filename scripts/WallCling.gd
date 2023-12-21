extends PlayerState
class_name WallCling

@export var Cling_timer: Timer


# Defines what happens when the state is entered
func Enter():
	player.climb_bar.show()
	if player.sprite.flip_h:
		player.sprite.flip_h = false
		player.sprite.position.x = -5
		player.climb_bar.position.x = -5
	else:
		player.sprite.flip_h = true
		player.sprite.position.x = 5
		player.climb_bar.position.x = 5
	player.debug_label.text = "Wall Cling"
	player.animation_player.current_animation = "Wall_Cling"
	player.canJump = true
	if player.time_left > 0:
		Cling_timer.start(player.time_left)
	else:
		Cling_timer.start(player.cling_time)


# Defines what happens when the state is exited
func Exit():
	player.time_left = Cling_timer.time_left
	Cling_timer.stop()
	player.climb_bar.hide()


# Defines what happens when the state is updated every frame (Non physics related)
func Update(delta: float):
	player.climb_bar.value = Cling_timer.time_left
	player.update_dash_cooldown()


# Defines what happens when the state is updated every frame (Physics related)
func Physics_Update(delta: float):
	if Input.is_action_pressed("jump"):
		state_machine.transition_to("Jump")
	elif Input.is_action_pressed("dash"):
		state_machine.transition_to("Dash")
	elif !player.sprite.flip_h and Input.is_action_just_pressed("move_left"):
		state_machine.transition_to("Fall")
	elif player.sprite.flip_h and Input.is_action_just_pressed("move_right"):
		state_machine.transition_to("Fall")


func _on_Cling_timer_timeout():
	state_machine.transition_to("Fall")
	player.canCling = false
	player.time_left = -1
