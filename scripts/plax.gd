extends Node2D

# Exported variable to adjust the parallax layer in the Godot editor.
@export var layer = 1

# Speed offset for the parallax effect.
var speedOffset = 0.2

# Reference to the player node, assumed to be named "Sarang".
@onready var player = get_node("../../Sarang")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	assert(player != null, "Sarang node not found")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update position for the parallax effect.
	# The position of this node is set based on the player's position,
	# multiplied by the layer and speedOffset for the parallax effect.
	position = -player.position * layer * speedOffset

