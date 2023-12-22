extends Node

@export var LevelTime: int
@onready var LevelTimer: Timer = $LevelTimer
#@onready var player : Player = $Sarang


# Called when the node enters the scene tree for the first time.
func _ready():
	LevelTimer.start(LevelTime)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	UiManager.emit_signal("time_update", LevelTimer.time_left)


func _on_LevelTimer_timeout():
	# Put code to reset level or move to next level here????
	pass
