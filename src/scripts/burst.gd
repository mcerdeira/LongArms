extends KinematicBody2D
var dir = 0
var vspeed = Vector2.ZERO
var timer = 0
var _speed = 250

func initialize(_dir):
	timer = 0.8
	dir = _dir

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	timer -= 1 * delta
	if (timer <= 0):# or is_on_wall()):
		queue_free()
		get_parent().remove_child(self)
	else:
		vspeed.x += (_speed * delta) * dir
		if dir == 1:
			vspeed = move_and_slide(vspeed, Vector2.RIGHT)
		else:
			vspeed = move_and_slide(vspeed, Vector2.LEFT)



func _on_area_body_entered(body):
	if "me_name" in body:
		if body.me_name == "SKELETON":
			body.really_die()
