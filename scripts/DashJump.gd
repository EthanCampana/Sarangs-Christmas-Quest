extends PlayerState
class_name DashJump

var prev_position: float


# Defines what happens when the state is entered
func Enter():
	prev_position = 999999
	player.debug_label.text = "Dash-Jump"
	player.animation_player.current_animation = "Jump"
	player.canJump = false
	player.velocity.y = player.jump_velocity * 1.1


# Defines what happens when the state is exited
func Exit():
	pass


# Defines what happens when the state is updated every frame (Physics related)
func Physics_Update(delta: float):
	player.apply_gravity(delta)

	player.handle_movement(self, delta)
	if prev_position < player.position.y:
		state_machine.transition_to("Fall")
	prev_position = player.position.y
