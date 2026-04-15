extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.animatedSprite.play("floor_climbing")
	player.velocity = Vector2.ZERO

func physics_update(_delta: float) -> void:
	if not player.hooked:
		finished.emit(IDLE)
	elif player.is_pressing:
		_climb_logic()
	else:
		finished.emit(HOOKED)
	player.move_and_slide()

func _climb_logic() -> void:
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
		if move_dir == player.valid_moving_dir or move_dir == -player.valid_moving_dir:
			match move_dir:
				Vector2(-1,0), Vector2(0,1):
					player.animatedSprite.flip_h = true
				Vector2(1,0), Vector2(0,-1):
					player.animatedSprite.flip_h = false
			player.velocity = move_dir * player.climb_speed
