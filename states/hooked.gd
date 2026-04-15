extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.animatedSprite.play("idle")
	player.velocity = Vector2.ZERO

func physics_update(_delta: float) -> void:
	if not player.hooked:
		finished.emit(IDLE)
	elif player.is_pressing:
		finished.emit(CLIMBING)
	player.move_and_slide()
