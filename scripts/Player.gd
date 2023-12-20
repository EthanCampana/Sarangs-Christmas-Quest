extends CharacterBody2D
class_name Player

@export var jump_height: float = 50
@export var jump_time_to_peak: float = 0.5
@export var jump_time_to_descent: float = 0.5
@export var ACCELERATION: int = 400
@export var air_speed: int = 100
@export var air_friction: int = 75
@export var friction: int = 500
@export var dashSpeed: int = 175
@export var dashTime: float = 0.3
@export var dashCooldownTime: float = 1.0
@export var cling_time: float = 5.0
@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1
@onready
var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1
@onready var fall_gravity: float = (
	((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
)
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

@onready var debug_label: Label = $Label

var canJump = true
var canDash = true
var canCling = true

const MAX_SPEED = 150


func dash_cooldown_expired():
	canDash = true


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
			velocity.x += move_toward(velocity.x, direction * (MAX_SPEED + 150), air_speed * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, air_friction * delta)
		velocity.x = clamp(velocity.x, -(MAX_SPEED + 150), MAX_SPEED + 150)

	if currentState is Walk:
		var direction = get_input_direction()
		if direction:
			velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCELERATION * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, friction * delta)

	if currentState is Dash:
		velocity = currentState.dash_vector * dashSpeed

	move_and_slide()


func _ready():
	animation_player.play("Idle")


# Gets the appropriate Gravity to apply to the player.
func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity


# Applys the gravity to the player's y velocity.
func apply_gravity(delta: float):
	velocity.y += fall_gravity * delta


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
