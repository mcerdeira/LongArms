extends KinematicBody2D
var me_name = "KNIGHT"
export var gravity = 7
var idle = true
var player = null
var face = 1
var vspeed = Vector2.ZERO
export var _speed = 10

func _ready():
	player = get_parent().get_node("player")

func _physics_process(delta):
	if idle:
		if position.distance_to(player.position) <= 150:
			idle = false
		else:
			$sprite.playing = false
	else:
		$sprite.playing = true
		if position.x > player.position.x:
			if face == -1:
				vspeed = Vector2.ZERO
			face = 1
		else:
			if face == 1:
				vspeed = Vector2.ZERO
			face = -1
			
		$sprite.set_scale(Vector2(face, 1))
		position.x += (_speed * delta) * (face * -1)
		vspeed.y += gravity
		vspeed = move_and_slide(vspeed, Vector2.UP)		
