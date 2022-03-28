extends KinematicBody2D
var vspeed = Vector2.ZERO
export var face = 1
export var _speed = 500

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if visible:
		position.x += (_speed * delta) * face
