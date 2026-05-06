class_name Ant extends Player

func _in_proximity_to_attachable() -> bool:
	for body in $Area2D.get_overlapping_bodies():
		if body is AttachableWall:
			return true
	return false

func aplicar_gravedad(dir: Vector2) -> void:
	if dir == Vector2.ZERO:
		dir = Vector2(0,-1)
	gravity_dir = dir
	# Le decimos a Godot que el "techo" es lo opuesto a la gravedad
	# Esto permite que is_on_floor() funcione correctamente
	up_direction = -gravity_dir
	if abs(gravity_dir.x) >= abs(gravity_dir.y):
		gravity_dir_dis = Vector2(1*sign(gravity_dir.x),0)
	else:
		gravity_dir_dis = Vector2(0,1*sign(gravity_dir.y))
		
func change_orientation(g_dir: Vector2) -> void:
	rotation_degrees = g_dir.angle()*180/PI-90

func can_run() -> bool:
	if !is_pressing:
		return false
	var target = get_global_mouse_position()
	var diff = target - global_position
	
	if diff.length() <= 20:
		return false
	
	var move_dir = Vector2.ZERO
	if abs(diff.x) > abs(diff.y):
		move_dir = Vector2(sign(diff.x), 0)
	else:
		move_dir = Vector2(0, sign(diff.y))
	
	return move_dir not in [-gravity_dir, gravity_dir]

func _unhandled_input(event: InputEvent) -> void:
	pass

func _on_hook_button_button_down() -> void:
	pass
