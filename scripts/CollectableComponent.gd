extends Area2D
class_name CollectableComponent

@export var item: Item


# Detects when the player enters the area and determines which item did they pick up.
# @param area : Area2D
func _on_area_entered(area: Area2D):
	get_parent().queue_free()
	if item is Present:
		UiManager.emit_signal("item_collected", 1)
		GameStats.presents +=1
	if item is Anvil:
		UiManager.emit_signal("item_collected", 5)
		GameStats.presents +=5
		
