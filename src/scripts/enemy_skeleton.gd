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
var agro = 250
var attack_agro = 300
var jumping = false
var jump_speed = 250
var jump_ttl_total = 3
var jump_ttl = jump_ttl_total
var attacked = false
var bone_scn = preload("res://scenes/skeleton_bone.tscn")
var really_dead = false
var alpha = 1
var check_position_total = 0.8
var check_position = check_position_total
export var _speed = 60

func _ready():
	player = get_parent().get_node("player")

func die():
	dead = true
	dead_counter = 5
	$sprite.animation = "skeleton_die"
	$collider.set_deferred("disabled", true)
	
func really_die():
	really_dead = true
	$sprite.animation = "skeleton_die"
	$collider.set_deferred("disabled", true)

func _physics_process(delta):
	if really_dead:
		alpha -= 1 * delta
		$sprite.modulate.a = alpha
		if alpha <= 0:
			queue_free()
			get_parent().remove_child(self)
		
	elif dead:
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
		if position.distance_to(player.position) <= agro:
			idle = false
		else:
			$sprite.playing = false
	else:
		$sprite.playing = true
		
		if jumping and is_on_floor():
			$sprite.animation = "skeleton"
			jumping = false
			
		if jumping and !attacked:
			if vspeed.y > 0:
				attacked = true
				Attack()
		
		if !jumping and position.distance_to(player.position) <= attack_agro:
			jump_ttl -= 1 * delta
			if jump_ttl <= 0:
				$sprite.animation = "skeleton_attack"
				jump_ttl = jump_ttl_total
				vspeed.y = -jump_speed
				attacked = false
				jumping = true
		
		check_position -= 1 * delta
		if check_position <= 0:
			check_position = check_position_total
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

func Attack():
	var bone = bone_scn.instance()
	get_parent().add_child(bone)
	bone.set_position(position)
	bone.initialize(player)
