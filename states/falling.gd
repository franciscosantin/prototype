extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.animatedSprite.play("falling")
	_update_velocity()

func physics_update(_delta: float) -> void:
	_update_velocity()
	player.move_and_slide()

	if player.is_on_floor():
		finished.emit(IDLE)
	elif player.hooked:
		finished.emit(HOOKED)

func _update_velocity() -> void:
	var newVelocity = player.velocity + player.gravity_dir * player.gravity_power
	if newVelocity.length() > player.terminal_velocity:
		player.velocity = player.terminal_velocity*player.gravity_dir
	else:
		player.velocity = newVelocity
