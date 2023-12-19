extends PlayerState
class_name Fall

@export var CoyoteTime: Timer
var jumpBuffered: bool
var bufferWindow: float = 0


# Defines what happens when the state is entered
func Enter():
	bufferWindow = 0
	player.debug_label.text = "Fall"
	player.animation_player.current_animation = "Fall"
	CoyoteTime.start(1)


# Defines what happens when the state is exited
func Exit():
	jumpBuffered = false


# Defines what happens when the state is updated every frame (Physics related)
func Physics_Update(delta: float):
	player.apply_gravity(delta)

	player.handle_movement(self, delta)

	if bufferWindow >= delta * 10:
		jumpBuffered = false
		bufferWindow = 0

	if Input.is_action_just_pressed("dash") and player.canDash:
		state_machine.transition_to("Dash")
	elif Input.is_action_just_pressed("jump") and player.canJump:
		state_machine.transition_to("Jump")
	elif Input.is_action_just_pressed("jump") and not player.canJump:
		jumpBuffered = true

	if player.is_on_floor():
		player.canJump = true
		if jumpBuffered:
			state_machine.transition_to("Jump")
		elif is_equal_approx(player.velocity.x, 0.0):
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walk")

	bufferWindow += delta


func _on_coyote_time_timeout():
	player.canJump = false
