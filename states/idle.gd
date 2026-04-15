extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity = Vector2.ZERO

func physics_update(_delta: float) -> void:
	player.move_and_slide()

	if not player.is_on_floor():
		finished.emit(FALLING)
	elif player.is_pressing:
		finished.emit(RUNNING)
