extends KinematicBody2D
var InitialPos = Vector2.ZERO
var face = 1
export var _speed = 500

func _ready():
	pass # Replace with function body.

func init(_face):
	face = _face
	InitialPos = global_position

func _process(delta):
	position.x += (_speed * delta) * face
