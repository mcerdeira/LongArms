extends KinematicBody2D
var me_name = "KNIGHT"
export var gravity = 7
var idle = true
var player = null
var face = 1
var pre_attack = 0.5
var vspeed = Vector2.ZERO
var attacking = 0
var hit_points = 5
var stun_time = 0
export var _speed = 10

func _ready():
	player = get_parent().get_node("player")
	$attack_area.monitoring = false
	
func stun():
	stun_time = 2

func _physics_process(delta):
	if idle:
		if position.distance_to(player.position) <= 150:
			idle = false
		else:
			$sprite.playing = false
	else:
		if attacking > 0:
			$attack_area.monitoring = true
			$sprite.animation = "knight_attack"
			attacking -= 1 * delta
			if attacking <= 0:
				$attack_area.monitoring = false
				$sprite.animation = "knight"
				pre_attack = 0.5
		elif pre_attack <= 0 and $sprite.animation == "knight_pre_attack":
			$sprite.animation = "knight_attack"
			attacking = 1
		elif $sprite.animation != "knight_attack" and ($sprite.animation == "knight_pre_attack" or position.distance_to(player.position) <= 30):
			$sprite.animation = "knight_pre_attack"
			pre_attack -= 1 * delta
		else:
			pre_attack = 0.5 + stun_time
			stun_time = 0
			$sprite.animation = "knight"
			$sprite.playing = true
			if position.x > player.position.x:
				if face == -1:
					vspeed = Vector2.ZERO
					face = 1
					$sprite.set_scale(Vector2(face, 1))
					$attack_area.set_scale($sprite.scale)
			else:
				if face == 1:
					vspeed = Vector2.ZERO
					face = -1
					$sprite.set_scale(Vector2(face, 1))
					$attack_area.set_scale($sprite.scale)
					
			position.x += (_speed * delta) * (face * -1)

		vspeed.y += gravity
		vspeed = move_and_slide(vspeed, Vector2.UP)		

func _on_attack_area_body_entered(body):
	if attacking > 0:
		if body.name == "player":
			body.hitted(hit_points)
