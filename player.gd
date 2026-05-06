class_name Player extends CharacterBody2D

@export var walk_speed: float = 300.0
@export var climb_speed: float = 80.0
@export var gravity_power: float = 50.0
@export var terminal_velocity: float = 2000.0

var gravity_dir: Vector2 = Vector2.ZERO
var gravity_dir_dis: Vector2 = Vector2(0,-1)
var is_pressing: bool = false
var valid_moving_dir: Vector2 = Vector2(1,0)
var hooked: bool = false
var can_hook: bool = false
@onready var fsm := $StateMachine
@onready var hookBtn := $Control/HookButton
@onready var animatedSprite := $AnimatedSprite2D

enum SurfaceType { normal, attachable }

func _in_proximity_to_attachable() -> bool:
	for body in $Area2D.get_overlapping_bodies():
		if body is AttachableWall:
			return true
	return false

func get_surface_type() -> SurfaceType:
	var collision = get_last_slide_collision()
	if collision:
		var collider = collision.get_collider()
		if collider is AttachableWall:
			valid_moving_dir = collider.valid_moving_dir
			return SurfaceType.attachable
	return SurfaceType.normal

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
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		is_pressing = event.pressed

func _on_hook_button_button_down() -> void:
	if hooked:
		hooked = false
	elif _in_proximity_to_attachable():
		hooked = not hooked
