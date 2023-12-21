extends PlayerState
class_name Dash

var air_dash: bool = false
var is_dashing: bool = false
@export var dashTimer: Timer
@export var dashCooldown: Timer
var dash_vector: Vector2 = Vector2.ZERO


# Defines what happens when the state is entered
func Enter():
	player.canDash = false
	player.audio.stream = player.cat_dash.pick_random()
	player.audio.play()
	is_dashing = true
	player.debug_label.text = "Dash"
	player.animation_player.current_animation = "Dash"
	if not player.is_on_floor():
		air_dash = true
	if air_dash:
		dashTimer.start(player.airDashTime)
	else:
		dashTimer.start(player.dashTime)
	get_dash_direction()


# Defines what happens when the state is exited
func Exit():
	air_dash = false
	player.sprite.rotation_degrees = 0
	player.dash_bar.show()
	dashCooldown.start(player.dashCooldownTime)


# Defines what direction the player will dash in
func get_dash_direction():
	var direction = player.get_input_direction()
	var y_direction = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if direction == 0 and y_direction == 0:
		if player.sprite.flip_h:
			direction = 1
		else:
			direction = -1
	dash_vector.x = direction
	dash_vector.y = y_direction
	if player.sprite.flip_h:
		if dash_vector.x == 0 and dash_vector.y == 1:
			player.sprite.rotation_degrees = 90
		elif dash_vector.x == 0 and dash_vector.y == -1:
			player.sprite.rotation_degrees = -90
		elif dash_vector.x == 1 and dash_vector.y == 1 and air_dash:
			player.sprite.rotation_degrees = 45
		elif dash_vector.x == 1 and dash_vector.y == -1:
			player.sprite.rotation_degrees = -45
	else:
		if dash_vector.x == 0 and dash_vector.y == 1:
			player.sprite.rotation_degrees = -90
		elif dash_vector.x == 0 and dash_vector.y == -1:
			player.sprite.rotation_degrees = 90
		elif dash_vector.x == -1 and dash_vector.y == 1 and air_dash:
			player.sprite.rotation_degrees = -45
		elif dash_vector.x == -1 and dash_vector.y == -1:
			player.sprite.rotation_degrees = 45


# Defines what happens when the state is updated every frame (Physics related)
func Physics_Update(delta: float):
	if is_dashing:
		player.handle_movement(self, delta)
		if player.is_on_floor():
			if air_dash:
				player.sprite.rotation_degrees = 0
				if player.velocity.x == 0:
					state_machine.transition_to("Idle")
			player.canJump = true
			if Input.is_action_pressed("jump") and player.is_on_floor():
				state_machine.transition_to("DashJump")
	else:
		if player.is_on_floor():
			player.canJump = true
			if is_equal_approx(player.velocity.x, 0.0):
				state_machine.transition_to("Idle")
			else:
				state_machine.transition_to("Walk")
		else:
			state_machine.transition_to("Fall")


func on_dashTimer_timeout():
	is_dashing = false
