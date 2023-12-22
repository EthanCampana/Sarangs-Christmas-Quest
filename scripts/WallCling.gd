extends PlayerState
class_name WallCling

@export var Cling_timer: Timer
var cling_frames_before_jump = 0


# Defines what happens when the state is entered
func Enter():
	cling_frames_before_jump = 0
	player.climb_bar.show()
	if player.ray_cast_right.is_colliding():
		player.sprite.flip_h = false
		player.sprite.position.x = -5
		player.climb_bar.position.x = -5
	else:
		player.sprite.flip_h = true
		player.sprite.position.x = 5
		player.climb_bar.position.x = 5
	player.debug_label.text = "Wall Cling"
	player.animation_player.current_animation = "Wall_Cling"
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
	cling_frames_before_jump += 1
	if cling_frames_before_jump > 25:
		player.canJump = true
	player.climb_bar.value = Cling_timer.time_left
	player.update_dash_cooldown()


# Defines what happens when the state is updated every frame (Physics related)
func Physics_Update(delta: float):
	if Input.is_action_pressed("jump") and player.canJump:
		state_machine.transition_to("Jump")
	elif Input.is_action_pressed("dash") and player.canDash:
		state_machine.transition_to("Dash")
	elif !player.sprite.flip_h and Input.is_action_just_pressed("move_left"):
		state_machine.transition_to("Fall")
	elif player.sprite.flip_h and Input.is_action_just_pressed("move_right"):
		state_machine.transition_to("Fall")


func _on_Cling_timer_timeout():
	state_machine.transition_to("Fall")
	player.canCling = false
	player.time_left = -1
