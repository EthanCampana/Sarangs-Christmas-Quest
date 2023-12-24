extends Node2D

@onready var platform = $Sprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	platform.set_frame_coords(20)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
