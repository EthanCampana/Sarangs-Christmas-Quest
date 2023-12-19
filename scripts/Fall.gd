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
func Physics_Update(delta: float):
	player.apply_gravity(delta)

	player.handle_movement(self, delta)

	if player.is_on_floor():
		if is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")
