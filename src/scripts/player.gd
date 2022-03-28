extends KinematicBody2D

export var gravity = 7
var vspeed = Vector2.ZERO
var fist = null
var face = 1
export var player_speed = 150
export var player_jump_speed = 250
export var attacking = false
export var hooking = false
export var jumping = false

func _ready():
	fist = get_node("fist")
	fist.visible = false

func _physics_process(delta):
	var moving = false
	
	vspeed.y += gravity
	
	if !attacking and !hooking and Input.is_action_pressed("move_left"):
		position.x -= player_speed * delta
		$player_sprite.set_scale(Vector2(-1, 1))
		face = -1
		moving = true
	elif !attacking and !hooking and Input.is_action_pressed("move_right"):
		position.x += player_speed * delta
		$player_sprite.set_scale(Vector2(1, 1))
		face = 1
		moving = true
		
	if !attacking and Input.is_action_pressed("attack"):
		attacking = true 
		fist.face = face
		fist.position.x = $player_sprite.position.x + (12 * face)
		fist.visible = true
	
	if !hooking and Input.is_action_pressed("hook"):
		hooking = true
		fist.face = face
		fist.position.x = $player_sprite.position.x + (12 * face)
		fist.visible = true
		
	if jumping and is_on_floor():
		jumping = false
	
	if !attacking and !hooking and is_on_floor() and Input.is_action_pressed("jump"):
		jumping = true
		vspeed.y = -player_jump_speed
	
	if jumping:
		$player_sprite.animation = "jumping"
	elif moving:
		$player_sprite.animation = "walking"
	else:
		if attacking:
			$player_sprite.animation = "attackhook"
		elif hooking:
			$player_sprite.animation = "attackhook"
		else:
			$player_sprite.animation = "default"
			
	$player_sprite.playing = moving
	
	vspeed = move_and_slide(vspeed, Vector2.UP)

func process_status():
	if attacking:
		pass
	elif hooking:
		pass
	else:
		pass
