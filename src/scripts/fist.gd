extends KinematicBody2D
var InitialPos = Vector2.ZERO
var face = 1
var vspeed = Vector2.ZERO
var mode = ""
var action = ""
var timer = 0
var parent = null
export var _speed = 2000

func init(_face, _mode):
	parent = get_parent()
	action = "goto"
	timer = 0.3
	face = _face
	mode = _mode
	InitialPos = position

func _physics_process(delta):
	if action == "goto":
		timer -= 1 * delta
		vspeed.x += (_speed * delta) * face
		if face == 1:
			vspeed = move_and_slide(vspeed, Vector2.RIGHT)
		else:
			vspeed = move_and_slide(vspeed, Vector2.LEFT)
	elif action == "return":
		vspeed.x += (_speed * delta) * (face * -1)
		if (face *-1) == 1:
			vspeed = move_and_slide(vspeed, Vector2.RIGHT)
		else:
			vspeed = move_and_slide(vspeed, Vector2.LEFT)
	
	if action == "goto":
		if (timer <= 0 or is_on_ceiling() or is_on_floor() or is_on_ceiling()):
			if mode == "attack":
				if action == "goto":
					vspeed = Vector2.ZERO
					action = "return"
			else:
				if action == "goto":
					vspeed = Vector2.ZERO
					action = "return"
	elif action == "return":
		if position.distance_to(InitialPos) <= 5:
			if mode == "attack":
				vspeed = Vector2.ZERO
				parent.FinishAttack()
			else:
				vspeed = Vector2.ZERO
				parent.FinishHook()

