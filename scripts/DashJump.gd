extends PlayerState
class_name DashJump

var prev_position: float


# Defines what happens when the state is entered
func Enter():
	player.jumpHeld = true
	prev_position = 999999
	player.debug_label.text = "Dash-Jump"
	player.animation_player.current_animation = "Jump"
	player.canJump = false
	player.velocity.y = player.jump_velocity * 1.1


# Defines what happens when the state is updated every frame (Non physics related)
func Update(delta: float):
	player.update_dash_cooldown()


# Defines what happens when the state is exited
func Exit():
	pass


# Defines what happens when the state is updated every frame (Physics related)
func Physics_Update(delta: float):
	if Input.is_action_just_released("jump"):
		player.jumpHeld = false
	player.apply_gravity(delta)

	player.handle_movement(self, delta)
	if Input.is_action_just_pressed("ui_up") and player.is_on_wall() and player.canCling:
		state_machine.transition_to("WallCling")
	elif prev_position < player.position.y:
		state_machine.transition_to("Fall")
	prev_position = player.position.y
