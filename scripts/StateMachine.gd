extends Node
class_name StateMachine

@export var initial_state: State

var current_state: State

signal transitioned(state: State)
var states: Dictionary = {}


func _ready():
	current_state = initial_state
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_machine = self


func _process(delta: float):
	if current_state:
		current_state.Update(delta)


func _physics_process(delta: float):
	if current_state:
		current_state.Physics_Update(delta)


# The State Machine transitions to the target state
func transition_to(target_state: String):
	if not states.get(target_state.to_lower()):
		return
	states[current_state.name.to_lower()].Exit()
	current_state = states.get(target_state.to_lower())
	states[current_state.name.to_lower()].Enter()
	emit_signal("transitioned", current_state.name)


func _on_sarang_change_state(stateName: String):
	transition_to(stateName)
