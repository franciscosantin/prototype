extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity_space_override = Area2D.SPACE_OVERRIDE_REPLACE
	gravity = 980
	gravity_direction = Vector2.RIGHT



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	var real_g = Input.get_gravity()
	if abs(real_g.x) > abs(real_g.y):
		# sign() devuelve 1 si es positivo o -1 si es negativo
		gravity_direction = Vector2(sign(real_g.x), 0)
	else:
		gravity_direction = Vector2(0,-1 * sign(real_g.y))
	var normalized_g = real_g.normalized()
	gravity_direction = Vector2(normalized_g.x, -normalized_g.y)
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
	cuerpo.rotation_degrees = Vector2(gravity_direction.x, -gravity_direction.y).angle()
