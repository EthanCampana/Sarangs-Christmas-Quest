extends PlayerState
class_name Walk


# Defines what happens when the state is entered
func Enter():
	player.debug_label.text = "Walk"
	player.animation_player.current_animation = "Walk"


# Defines what happens when the state is exited
func Exit():
	pass


# Defines what happens when the state is updated every frame (Physics related)
func PhysicsUpdate(delta: float):
	player.apply_gravity(delta)
	var direction = player.get_input_direction()
	if direction:
		player.velocity.x = move_toward(
			player.velocity.x, direction * player.MAX_SPEED, player.ACCELERATION * delta
		)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, 300 * delta)

	if Input.is_action_pressed("jump") and player.is_on_floor():
		state_machine.transition_to("Jump")
	if player.velocity.y >= 0 and not player.is_on_floor():
		state_machine.transition_to("Fall")
	player.move_and_slide()
