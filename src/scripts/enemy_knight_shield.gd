extends KinematicBody2D
var me_name = "KNIGHT_SHIELD"
export var gravity = 7
var idle = true
var player = null
var face = 1
var pre_attack_total = 0.1
var pre_attack = pre_attack_total
var vspeed = Vector2.ZERO
var attacking = 0
var stun_time = 0
var hitted_time = 0
var hitted_hide = 0
var alpha = 1
var dead = false
var hit_points = 5
var life = 5
var agro = 150
var attack_agro = 60
export var _speed = 10

func _ready():
	player = get_parent().get_node("player")
	$attack_area.monitoring = false

func stun():
	stun_time = 2.3

func hitted():
	if hitted_time <= 0:
		life -= 1
		hitted_time = 3
		if life <= 0:
			life = 0
			dead = true

func _physics_process(delta):
	if hitted_time > 0:
		hitted_hide -= 1 * delta
		if hitted_hide <= 0:
			hitted_hide = 0.1
			$sprite.visible = !$sprite.visible 
		
		hitted_time -= 1 * delta
		if hitted_time <= 0:
			$sprite.visible = true
			hitted_time = 0
			hitted_hide = 0
	if dead:
		alpha -= 1 * delta
		$sprite.modulate.a = alpha
		if alpha <= 0:
			queue_free()
			get_parent().remove_child(self)
		
	elif idle:
		if position.distance_to(player.position) <= agro:
			idle = false
		else:
			$sprite.playing = false
	else:
		if attacking > 0:
			$attack_area.monitoring = true
			$sprite.animation = "knight_shield_attack"
			$sprite.speed_scale = 3
			attacking -= 1 * delta
			if attacking <= 0:
				$sprite.speed_scale = 1
				$attack_area.monitoring = false
				$sprite.animation = "knight_shield"
				pre_attack = pre_attack_total
		elif pre_attack <= 0 and $sprite.animation == "knight_shield_pre_attack":
			$sprite.animation = "knight_shield_attack"
			stun_time = 0
			attacking = 1
		elif $sprite.animation != "knight_shield_attack" and ($sprite.animation == "knight_shield_pre_attack" \
			or position.distance_to(player.position) <= attack_agro):
				$sprite.animation = "knight_shield_pre_attack"
				pre_attack -= 1 * delta
		else:
			pre_attack = pre_attack_total + stun_time
			$sprite.animation = "knight_shield"
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
