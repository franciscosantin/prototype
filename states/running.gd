extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	if player.is_pressing:
		_run_logic()

func _run_logic() -> void:
	var target = player.get_global_mouse_position()
	var diff = target - player.global_position
	
	if diff.length() > 20:
		# Solo permitimos caminar si la dirección es distinta a la gravedad
		# (Opcional: esto evita que el personaje intente "atravesar" el suelo)
		var move_dir = Vector2.ZERO
		if abs(diff.x) > abs(diff.y):
			move_dir = Vector2(sign(diff.x), 0)
		else:
			move_dir = Vector2(0, sign(diff.y))
		
		# Si el jugador intenta caminar hacia donde ya hay gravedad, lo ignoramos
		if move_dir != player.gravity_dir:
			player.velocity = move_dir * player.walk_speed

func physics_update(_delta: float) -> void:
	player.move_and_slide()
	if not player.is_on_floor:
		finished.emit(FALLING)
	elif not player.is_pressing:
		finished.emit(IDLE)
	else:
		_run_logic()
