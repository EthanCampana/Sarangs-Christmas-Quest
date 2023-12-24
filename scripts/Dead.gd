extends PlayerState
class_name Death


# Defines what happens when the state is entered
func Enter():
	player.animation_player.current_animation = "Die"
	player.audio.stream = player.cat_meow.pick_random()
	player.audio.play()




# Defines what happens when the state is updated every frame (Physics related)
func Physics_Update(delta: float):
	if not player.animation_player.is_playing():
		state_machine.transition_to("idle")

# Defines what happens when the state is exited
func Exit():
	player.isDead = false
	player.animation_player.play_backwards("Die")
	await player.animation_player.animation_finished
