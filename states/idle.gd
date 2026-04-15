extends PlayerState

func enter(previous_state_path: String, data := {}) -> void:
	player.animatedSprite.play("idle")
	player.velocity = Vector2.ZERO

func physics_update(_delta: float) -> void:
	player.move_and_slide()

	if not player.is_on_floor():
		finished.emit(FALLING)
	elif player.hooked:
		finished.emit(HOOKED)
	elif player.can_run():
		finished.emit(RUNNING)
