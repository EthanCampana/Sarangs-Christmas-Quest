extends PlayerState
class_name Walk


# Defines what happens when the state is entered
func Enter():
	player.debug_label.text = "Walk"
	player.animation_player.current_animation = "Walk"


func Update(delta: float):
	player.update_dash_cooldown()
	
# Defines what happens when the state is exited
func Exit():
	pass


# Defines what happens when the state is updated every frame (Physics related)
func Physics_Update(delta: float):
	player.apply_gravity(delta)
	player.handle_movement(self, delta)

	if Input.is_action_pressed("jump") and player.is_on_floor():
		state_machine.transition_to("Jump")
	elif Input.is_action_just_pressed("dash") and player.canDash:
		state_machine.transition_to("Dash")
	elif player.velocity.y >= 0 and not player.is_on_floor():
		state_machine.transition_to("Fall")
	elif player.velocity.x == 0:
		state_machine.transition_to("Idle")
