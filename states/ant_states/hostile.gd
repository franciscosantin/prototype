extends AntState

func enter(previous_state_path: String, data := {}) -> void:
	pass

func physics_update(_delta: float) -> void:
	if not ant.is_on_floor():
		finished.emit(FALLING)
	elif !ant.player_in_proximity:
		finished.emit(IDLE)
	else:
		moveToPlayerPosition()
	ant.move_and_slide()

func moveToPlayerPosition() -> void:
	if ant.player == null:
		return
	ant.navigation.target_position = ant.player.position
	var next_path_pos := ant.navigation.get_next_path_position()
	ant.get_moving_dir()
	ant.velocity = ant.walk_speed * ant.position.direction_to(next_path_pos)
