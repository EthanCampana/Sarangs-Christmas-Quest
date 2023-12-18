extends CharacterBody2D
class_name Player

@onready var jump_height: float = 100
@onready var jump_time_to_peak: float = 0.5
@onready var jump_time_to_descent: float = 0.5
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
const ACCELERATION = 200


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
