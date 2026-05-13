extends AntState

func enter(previous_state_path: String, data := {}) -> void:
	ant.velocity = Vector2.ZERO
	pass

func physics_update(_delta: float) -> void:
	if not ant.is_on_floor():
		finished.emit(FALLING)
	elif ant.player_in_proximity:
		finished.emit(HOSTILE)
	ant.move_and_slide()
