extends CanvasLayer
@onready var time: Label = $Control/HBoxContainer/Time


# Called when the node enters the scene tree for the first time.
func _ready():
	UiManager.connect("time_update", _on_time_update)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_time_update(newTime: float):
	self.time.text = "Time " + str(int(newTime))
