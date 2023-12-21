extends PlayerState
class_name Idle

@onready var timer: Timer = $Timer


# Defines what happens when the state is entered
func Enter():
	timer.start(10)
	player.debug_label.text = "Idle"
	player.animation_player.current_animation = "Idle"


# Defines what happens when the state is updated every frame (Non physics related)
func Update(delta: float):
	player.update_dash_cooldown()


# Defines what happens when the state is exited
func Exit():
	timer.stop()


# Defines what happens when the state is updated every frame (Physics related)
func Physics_Update(delta: float):
	player.apply_gravity(delta)
	var direction = player.get_input_direction()
	if direction:
		state_machine.transition_to("Walk")
	if Input.is_action_just_pressed("dash") and player.canDash:
		state_machine.transition_to("Dash")
	if Input.is_action_pressed("jump") and player.is_on_floor():
		state_machine.transition_to("Jump")
	if player.velocity.y > 0 and not player.is_on_floor():
		state_machine.transition_to("Fall")
	player.move_and_slide()


func _on_timer_timeout():
	player.animation_player.current_animation = "Playful_Idle"
