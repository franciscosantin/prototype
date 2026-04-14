extends CharacterBody2D

@export var walk_speed: float = 300.0
@export var gravity_power: float = 800.0

var gravity_dir: Vector2 = Vector2.ZERO
var is_pressing: bool = false

var state: Callable = idle_handler

func idle_handler() -> void:
	velocity = Vector2.ZERO
	if not is_on_floor():
		state = falling_handler
	elif is_pressing:
		state = running_handler
	move_and_slide()

func running_handler() -> void:
	if not is_on_floor():
		state = falling_handler
	elif is_pressing:
		_run_logic()
	else:
		state = idle_handler
	move_and_slide()

func _run_logic() -> void:
	var target = get_global_mouse_position()
	var diff = target - global_position
	
	if diff.length() > 20:
		# Solo permitimos caminar si la dirección es distinta a la gravedad
		# (Opcional: esto evita que el personaje intente "atravesar" el suelo)
		var move_dir = Vector2.ZERO
		if abs(diff.x) > abs(diff.y):
			move_dir = Vector2(sign(diff.x), 0)
		else:
			move_dir = Vector2(0, sign(diff.y))
		
		# Si el jugador intenta caminar hacia donde ya hay gravedad, lo ignoramos
		if move_dir != gravity_dir:
			velocity = move_dir * walk_speed

func falling_handler() -> void:
	if not is_on_floor():
		_apply_gravity()
	elif is_pressing:
		state = running_handler
	else:
		state = idle_handler
	move_and_slide()

func _apply_gravity() -> void:
	velocity = gravity_dir * gravity_power

func aplicar_gravedad(dir: Vector2) -> void:
	gravity_dir = dir
	# Le decimos a Godot que el "techo" es lo opuesto a la gravedad
	# Esto permite que is_on_floor() funcione correctamente
	up_direction = -gravity_dir

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		is_pressing = event.pressed

func _physics_process(delta: float) -> void:
	state.call()
