class_name Ant extends CharacterBody2D

@export var health: float = 100.0
@export var walk_speed: float = 300.0
@export var climb_speed: float = 80.0
@export var gravity_power: float = 50.0
@export var terminal_velocity: float = 2000.0

var gravity_dir: Vector2 = Vector2.ZERO
var gravity_dir_dis: Vector2 = Vector2(0,-1)
var attachable_walls = []
var current_floor: StaticBody2D = null
var player_in_proximity := false
var player: Player = null
var valid_moving_dir: Vector2 = Vector2.ZERO
@onready var fsm := $StateMachine
@onready var animatedSprite := $AnimatedSprite2D
@onready var detectionArea := $DetectionArea
@onready var navigation: NavigationAgent2D = $NavigationAgent2D

func _in_proximity_to_attachable() -> bool:
	for body in $Area2D.get_overlapping_bodies():
		if body is AttachableWall:
			return true
	return false

func update_floor() -> void:
	pass

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

func get_moving_dir() -> void:
	var collision := get_last_slide_collision()
	var collision_normal := collision.get_normal()
	print("Normal a la colisión:")
	print(collision_normal)
	valid_moving_dir = Vector2(collision_normal.y, collision_normal.x).normalized()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is StaticBody2D:
		attachable_walls.append(body)
	if current_floor == null:
		current_floor = attachable_walls.get(0)

func _on_detection_area_body_entered(body: Node2D) -> void:
	print("Un cuerpo entro al area")
	print(body)
	if body is Player:
		player_in_proximity = true
		player = body
	else:
		player_in_proximity = false
