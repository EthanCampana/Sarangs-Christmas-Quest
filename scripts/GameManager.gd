extends Node

@export var LevelTime: int
@onready var LevelTimer: Timer = $LevelTimer
@onready var player : Player = $Sarang
@export var nextLevel : String
@export var currentLevel : String
var spawn_pos : Vector2 = Vector2.ZERO
var deathChecked : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	LevelTimer.start(LevelTime)
	spawn_pos = player.global_position


func handle_revive():
	player.global_position = spawn_pos
	deathChecked = false
	
func handle_death():
	player.emit_signal("change_state","Death")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	UiManager.emit_signal("time_update", LevelTimer.time_left)
	print(player.isDead)
	if player.isDead and not deathChecked:
		handle_death()
		deathChecked = true
	if not player.isDead and deathChecked:
		handle_revive()
	
	
func restart_level():
	SceneTransition.change_scene(currentLevel)
	LevelTimer.start(LevelTime)
	player.global_position = spawn_pos


func _on_level_timer_timeout():
	player.emit_signal("change_state","Death")
	restart_level()
	
