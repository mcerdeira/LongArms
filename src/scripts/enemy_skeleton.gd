extends KinematicBody2D
var me_name = "SKELETON"
export var gravity = 7
var idle = true
var player = null
var face = 1
var vspeed = Vector2.ZERO
var revive = false
var dead = false
var dead_counter = 0
export var _speed = 30

func _ready():
	player = get_parent().get_node("player")

func die():
	dead = true
	dead_counter = 8
	$sprite.animation = "skeleton_die"
	$collider.set_deferred("disabled", true)

func _physics_process(delta):
	if dead:
		if !revive:
			if $sprite.frame == 1:
				$sprite.playing = false
				
			dead_counter -= 1 * delta
			if dead_counter <= 0:
				revive = true
		else:
			if !$sprite.is_playing():
				$sprite.play($sprite.animation, true)
			else:
				if $sprite.frame == 0:
					$sprite.playing = false
					revive = false
					dead = false
					$sprite.animation = "skeleton"
					$collider.set_deferred("disabled", false)
			
	elif idle:
		if position.distance_to(player.position) <= 150:
			idle = false
		else:
			$sprite.playing = false
	else:
		$sprite.playing = true
		if position.x > player.position.x:
			if face == -1:
				face = 1
				$sprite.scale = (Vector2(face, 1))
				vspeed = Vector2.ZERO
		else:
			if face == 1:
				face = -1
				$sprite.scale = (Vector2(face, 1))
				vspeed = Vector2.ZERO
			
		position.x += (_speed * delta) * (face * -1)
		vspeed.y += gravity
		vspeed = move_and_slide(vspeed, Vector2.UP)
