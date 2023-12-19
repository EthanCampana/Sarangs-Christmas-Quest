extends CharacterBody2D
class_name Player

@export var jump_height: float = 100
@export var jump_time_to_peak: float = 0.5
@export var jump_time_to_descent: float = 0.5
@export var ACCELERATION: int = 500
@export var air_speed: int = 300
@export var air_friction: int = 100
@export var friction: int = 500
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

const MAX_SPEED = 200


func handle_movement(currentState: PlayerState, delta: float):
	var direction = get_input_direction()

	if currentState is Fall or currentState is Jump:
		if direction:
			velocity.x += air_speed * direction * delta
		else:
			velocity.x = move_toward(velocity.x, 0, air_friction)
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)

	if currentState is Walk:
		if direction:
			velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCELERATION * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, friction * delta)

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