extends Node2D
class_name BackgroudAudioManager

@export var PreLoopFile: AudioStream
@export var LoopFile: AudioStream
@onready var PreLoop: AudioStreamPlayer = $PreLoop
@onready var Loop: AudioStreamPlayer = $PreLoop


func _ready():
	PreLoop.stream = PreLoopFile
	Loop.stream = LoopFile
	PreLoop.play()


func _on_pre_loop_finished():
	Loop.play()
