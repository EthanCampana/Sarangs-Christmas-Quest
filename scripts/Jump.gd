extends PlayerState
class_name Jump

var prev_position: float


# Defines what happens when the state is entered
func Enter():
	player.jumpHeld = true
	prev_position = 999999
	if player.sprite.flip_h:
		player.audio.stream = player.cat_jump_right.pick_random()
	else:
		player.audio.stream = player.cat_jump_left.pick_random()
	player.audio.play()
	player.debug_label.text = "Jump"
	player.animation_player.current_animation = "Jump"
	player.canJump = false
	player.velocity.y = player.jump_velocity


func Update(delta: float):
	player.update_dash_cooldown()


# Defines what happens when the state is exited
func Exit():
	player.jumpHeld = false
	pass


# Defines what happens when the state is updated every frame (Physics related)
func Physics_Update(delta: float):
	if Input.is_action_just_released("jump"):
		player.jumpHeld = false
	player.apply_gravity(delta)

	player.handle_movement(self, delta)

	if Input.is_action_just_pressed("dash") and player.canDash:
		state_machine.transition_to("Dash")
	elif Input.is_action_just_pressed("ui_up") and player.ray_cast_check() and player.canCling:
		state_machine.transition_to("WallCling")
	elif prev_position < player.position.y:
		state_machine.transition_to("Fall")
	prev_position = player.position.y
