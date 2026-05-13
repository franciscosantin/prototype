extends AntState

func enter(previous_state_path: String, data := {}) -> void:
	ant.velocity += ant.gravity_power * ant.gravity_dir

func physics_update(_delta: float) -> void:
	if ant.is_on_floor():
		finished.emit(IDLE)
	else:
		ant.velocity += ant.gravity_power * ant.gravity_dir
	ant.move_and_slide()
