class_name Player extends CharacterBody2D

@export var walk_speed: float = 300.0
@export var climb_speed: float = 80.0
@export var gravity_power: float = 800.0

var gravity_dir: Vector2 = Vector2.ZERO
var is_pressing: bool = false
var valid_moving_dir: Vector2 = Vector2(1,0)
var hooked: bool = false
@onready var fsm := $StateMachine
@onready var hookBtn := $Control/HookButton
@onready var animatedSprite := $AnimatedSprite2D

enum SurfaceType { normal, attachable }

func get_surface_type() -> SurfaceType:
	var collision = get_last_slide_collision()
	if collision:
		var collider = collision.get_collider()
		if collider is AttachableWall:
			valid_moving_dir = collider.valid_moving_dir
			collider.global_position*collider.valid_moving_dir - global_position*collider.valid_moving_dir
			return SurfaceType.attachable
	return SurfaceType.normal

func aplicar_gravedad(dir: Vector2) -> void:
	if dir == Vector2.ZERO:
		dir = Vector2(0,-1)
	gravity_dir = dir
	# Le decimos a Godot que el "techo" es lo opuesto a la gravedad
	# Esto permite que is_on_floor() funcione correctamente
	up_direction = -gravity_dir

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		is_pressing = event.pressed

func _on_hook_button_button_down() -> void:
	if hooked:
		hooked = false
	else:
		match get_surface_type():
			SurfaceType.attachable:
				hooked = not hooked
