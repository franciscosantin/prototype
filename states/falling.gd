extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity = player.gravity_dir * player.gravity_power

func physics_update(_delta: float) -> void:
	player.velocity = player.gravity_dir * player.gravity_power
	print(player.velocity)
	player.move_and_slide()

	if player.is_on_floor():
		finished.emit(IDLE)
