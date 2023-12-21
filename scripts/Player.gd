extends CharacterBody2D
class_name Player

@export var jump_height: float = 48
@export var jump_time_to_peak: float = 0.5
@export var jump_time_to_descent: float = 0.4
@export var ACCELERATION: int = 1000
@export var air_speed: int = 700
@export var air_friction: int = 400
@export var friction: int = 500
@export var dashSpeed_x: int = 175
@export var dashSpeed_y: int = 125
@export var dashTime: float = 0.5
@export var airDashTime: float = 0.5
@export var dashCooldownTime: float = 5.0
@export var cling_time: float = 5.0
@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1
@onready
var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1
@onready var fall_gravity: float = (
	((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
)

@onready var variable_jump_gravity: float = ((jump_velocity ** 2) / (2 * jump_height)) * -1

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var debug_label: Label = $Label
@onready var climb_bar: TextureProgressBar = $Sprite2D/TextureProgressBar
@onready var dash_bar: TextureProgressBar = $DashBar
@onready var dash_timer: Timer = $StateMachine/Dash/DashCooldown
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
var canJump = true
var canDash = true
var canCling = true
var jumpHeld = false
var time_left = -1
const MAX_SPEED = 150


func ray_cast_check() -> bool:
	return ray_cast_left.is_colliding() or ray_cast_right.is_colliding()


func dash_cooldown_expired():
	canDash = true
	dash_bar.hide()


func update_dash_cooldown():
	dash_bar.value = dashCooldownTime - dash_timer.time_left


func handle_movement(currentState: PlayerState, delta: float):
	if currentState is Fall or currentState is Jump:
		var direction = get_input_direction()
		if direction:
			velocity.x = move_toward(velocity.x, direction * MAX_SPEED, air_speed * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, air_friction * delta)

	elif currentState is DashJump:
		var direction = get_input_direction()
		if direction:
			velocity.x += move_toward(velocity.x, direction * (MAX_SPEED + 50), air_speed * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, air_friction * delta)
		velocity.x = clamp(velocity.x, -(MAX_SPEED + 50), MAX_SPEED + 50)

	if currentState is Walk:
		var direction = get_input_direction()
		if direction:
			velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCELERATION * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, friction * delta)

	if currentState is Dash:
		velocity.x = currentState.dash_vector.x * dashSpeed_x
		velocity.y = currentState.dash_vector.y * dashSpeed_y

	move_and_slide()


func _ready():
	animation_player.play("Idle")
	dash_bar.max_value = dashCooldownTime
	climb_bar.max_value = cling_time


# Gets the appropriate Gravity to apply to the player.
func get_gravity() -> float:
	return jump_gravity if jumpHeld else fall_gravity


# Applys the gravity to the player's y velocity.
func apply_gravity(delta: float):
	velocity.y += get_gravity() * delta


# Returns the movement direction of the player movement 1=Right, -1=Left, 0=No movement/ Neutral.
func get_input_direction() -> int:
	var dir = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if dir > 0:
		sprite.flip_h = true
	if dir < 0:
		sprite.flip_h = false
	return dir


func get_wall_cling_direction():
	if sprite.flip_h:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
