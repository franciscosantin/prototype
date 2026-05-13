# Boilerplate class to get full autocompletion and type checks for the `player` when coding the player's states.
# Without this, we have to run the game to see typos and other errors the compiler could otherwise catch while scripting.
class_name AntState extends State

const IDLE = "Idle"
const HOSTILE = "Hostile"
const FALLING = "Falling"

var ant: Ant

func _ready() -> void:
	await owner.ready
	ant = owner as Ant
	assert(ant != null)
