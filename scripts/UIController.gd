extends CanvasLayer
@onready var time: Label = $Control/HBoxContainer/Time
@onready var presents: Label = $Control/HBoxContainer2/Presents

var score: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	UiManager.connect("time_update", _on_time_update)
	UiManager.connect("item_collected", _on_item_collect)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_time_update(newTime: float):
	self.time.text = "Time " + str(int(newTime))


func _on_item_collect(value: int):
	score += value
	presents.text = str(score)
