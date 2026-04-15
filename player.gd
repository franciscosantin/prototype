class_name Player extends CharacterBody2D

@export var walk_speed: float = 300.0
@export var gravity_power: float = 800.0

var gravity_dir: Vector2 = Vector2.ZERO
var is_pressing: bool = false
@onready var fsm := $StateMachine

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
