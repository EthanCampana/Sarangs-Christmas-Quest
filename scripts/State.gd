class_name State

extends Node

var state_machine: StateMachine = null


# Defines what happens when the state is entered
func Enter():
	pass


# Defines what happens when the state is exited
func Exit():
	pass


# Defines what happens when the state is updated every frame (Non physics related)
func Update(delta: float):
	pass


# Defines what happens when the state is updated every frame (Physics related)
func Physics_Update(delta: float):
	pass
