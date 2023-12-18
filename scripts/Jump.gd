extends PlayerState
class_name Jump

var prev_velocity: float = 0


# Defines what happens when the state is entered
func Enter():
	player.debug_label.text = "Jump"
	player.animation_player.current_animation = "jump"
	player.canJump = false
	player.velocity.y = player.jump_velocity


# Defines what happens when the state is exited
func Exit():
	pass


# Defines what happens when the state is updated every frame (Physics related)
func PhysicsUpdate(delta: float):
	prev_velocity = player.velocity.y
	player.apply_gravity(delta)
	if prev_velocity < player.velocity.y:
		state_machine.transition_to("fall")

	var direction = player.get_input_direction()
	if direction:
		player.velocity.x *= direction
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, 50)

	player.move_and_slide()
