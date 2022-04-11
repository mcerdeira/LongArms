extends KinematicBody2D
var me_name = "KNIGHT"
export var gravity = 7
var idle = true
var player = null
export var face = 1
var pre_attack_total = 0.2
var pre_attack = pre_attack_total
var vspeed = Vector2.ZERO
var attacking = 0
var hit_points = 5
var stun_time = 0
var hitted_time = 0
var hitted_hide = 0
var alpha = 1
var life = 3
var dead = false
var attack_agro = 30
var agro = 300
var agresive = false
var stop_agresive = 0
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
			$sprite.animation = "knight_attack"
			attacking -= 1 * delta
			if attacking <= 0:
				$attack_area.monitoring = false
				$sprite.animation = "knight"
				pre_attack = pre_attack_total
		elif pre_attack <= 0 and $sprite.animation == "knight_pre_attack":
			$sprite.animation = "knight_attack"
			stun_time = 0
			attacking = 1
		elif $sprite.animation != "knight_attack" and ($sprite.animation == "knight_pre_attack" \
			or position.distance_to(player.position) <= attack_agro):
				$sprite.animation = "knight_pre_attack"
				pre_attack -= 1 * delta
		else:
			pre_attack = pre_attack_total + stun_time
			$sprite.animation = "knight"
			$sprite.playing = true
			if position.x > player.position.x:
				if face == -1:
					vspeed = Vector2.ZERO
					face = 1
					_scale_all(face)
			else:
				if face == 1:
					vspeed = Vector2.ZERO
					face = -1
					_scale_all(face)
			
			var agr = 0 
			if agresive:
				agr = 35
				if stop_agresive > 0:
					stop_agresive -= 1 * delta
					if stop_agresive <= 0:
						stop_agresive = 0
						agresive = false
				
			position.x += ((_speed + agr) * delta) * (face * -1)

		vspeed.y += gravity
		vspeed = move_and_slide(vspeed, Vector2.UP)

func _scale_all(face):
	$sprite.set_scale(Vector2(face, 1))
	$attack_area.set_scale($sprite.scale)
	$detect_area.set_scale($sprite.scale)

func _on_attack_area_body_entered(body):
	if !dead and attacking > 0:
		if body.name == "player":
			body.hitted(hit_points)

func _on_detect_area_body_entered(body):
	if !dead and !idle and attacking <= 0:
		if body.name == "player":
			agresive = true

func _on_detect_area_body_exited(body):
	if agresive:
		if body.name == "player":
			stop_agresive = 5
