extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity_space_override = Area2D.SPACE_OVERRIDE_REPLACE
	gravity = 980
	gravity_direction = Vector2.RIGHT



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var real_g = Input.get_gravity()
	if abs(real_g.x) > abs(real_g.y):
		# sign() devuelve 1 si es positivo o -1 si es negativo
		gravity_direction = Vector2(sign(real_g.x), 0)
	else:
		gravity_direction = Vector2(0,-1 * sign(real_g.y))
	actualizar_cuerpos()
	
	
func actualizar_cuerpos() -> void:
	var cuerpos = get_overlapping_bodies()
	for cuerpo in cuerpos:
		if cuerpo is RigidBody2D:
			cuerpo.sleeping = false
		
		if cuerpo is CharacterBody2D:
			# Le pasamos la dirección de la gravedad al script del personaje
			if cuerpo.has_method("aplicar_gravedad"):
				cuerpo.aplicar_gravedad(gravity_direction)
			actualizar_orientacion(cuerpo)

func actualizar_orientacion(cuerpo: CharacterBody2D):
	if gravity_direction == Vector2(0, 1):
		cuerpo.rotation_degrees = 0
	elif gravity_direction == Vector2(0, -1):
		cuerpo.rotation_degrees = 180
	elif gravity_direction == Vector2(1, 0):
		cuerpo.rotation_degrees = -90
	elif gravity_direction == Vector2(-1, 0):
		cuerpo.rotation_degrees = 90
