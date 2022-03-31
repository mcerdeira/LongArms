extends KinematicBody2D
var InitialPos = Vector2.ZERO
var face = 1
var vspeed = Vector2.ZERO
var mode = ""
var action = ""
var timer = 0
var parent = null
var flag_direction = ""
export var _speed = 2300

func init(_face, _mode, _parent, _flag_direction):
	flag_direction = _flag_direction
	parent = _parent
	action = "goto"
	timer = 0.3
	face = _face
	mode = _mode
	InitialPos = position
	if flag_direction == "up":
		rotation_degrees = 270
	elif flag_direction == "down":
		rotation_degrees = 90
	else:
		$sprite.set_scale(Vector2(face, 1))

func _physics_process(delta):
	if action == "goto":
		timer -= 1 * delta
		if flag_direction == "":
			vspeed.x += (_speed * delta) * face
			if face == 1:
				vspeed = move_and_slide(vspeed, Vector2.RIGHT)
			else:
				vspeed = move_and_slide(vspeed, Vector2.LEFT)
		elif flag_direction == "up":
			vspeed.y -= (_speed * delta)
			vspeed = move_and_slide(vspeed, Vector2.UP)
		elif flag_direction == "down":
			vspeed.y += (_speed * delta)
			vspeed = move_and_slide(vspeed, Vector2.DOWN)
		
	elif action == "return":
		if flag_direction == "":
			vspeed.x += (_speed * delta) * (face * -1)
			if (face *-1) == 1:
				vspeed = move_and_slide(vspeed, Vector2.RIGHT)
			else:
				vspeed = move_and_slide(vspeed, Vector2.LEFT)
		elif flag_direction == "up":
			vspeed.y += (_speed * delta)
			vspeed = move_and_slide(vspeed, Vector2.DOWN)
		elif flag_direction == "down":
			vspeed.y -= (_speed * delta)
			vspeed = move_and_slide(vspeed, Vector2.UP)
	
	if action == "goto":
		if (timer <= 0 or is_on_ceiling() or is_on_floor() or is_on_wall()):
			if mode == "attack":
				if action == "goto":
					vspeed = Vector2.ZERO
					action = "return"
			else:
				if timer <= 0:
					vspeed = Vector2.ZERO
					action = "return"
				else:
					if action == "goto":
						vspeed = Vector2.ZERO
						action = "stay"
	elif action == "return":
		if position.distance_to(InitialPos) <= 5:
			if mode == "attack":
				vspeed = Vector2.ZERO
				parent.FinishAttack()
			else:
				vspeed = Vector2.ZERO
				parent.FinishHook()
	elif action == "stay":
		parent.GotoHook(face, to_global(position))

