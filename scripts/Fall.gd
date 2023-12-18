extends PlayerState
class_name Fall


# Defines what happens when the state is entered
func Enter():
	player.debug_label.text = "Fall"
	player.animation_player.current_animation = "Fall"


# Defines what happens when the state is exited
func Exit():
	player.canJump = true


# Defines what happens when the state is updated every frame (Physics related)
func PhysicsUpdate(delta: float):
	player.apply_gravity(delta)

	var direction = player.get_input_direction()
	if direction:
		player.velocity.x *= direction
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, 50)

	player.move_and_slide()

	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")
