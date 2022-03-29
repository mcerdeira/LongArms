extends KinematicBody2D

export var gravity = 7
var vspeed = Vector2.ZERO
var fist = null
var fist_scn = preload("res://scenes/fist.tscn")
var face = 1
export var player_speed = 150
export var player_jump_speed = 250
export var attacking = false
export var hooking = false
export var jumping = false
export var hook_hook_return = false

func _ready():
	pass

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
		
	if Input.is_action_pressed("attack"):
		Attack()
	
	if Input.is_action_pressed("hook"):
		Hook()
		
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
			update()
		elif hooking or hook_hook_return:
			$player_sprite.animation = "attackhook"
			update()
		else:
			$player_sprite.animation = "default"
			
	$player_sprite.playing = moving
	
	if hook_hook_return:
		pass
	
	vspeed = move_and_slide(vspeed, Vector2.UP)

func Attack():
	if !attacking and !hooking:
		attacking = true
		fist = fist_scn.instance()
		add_child(fist)
		fist.set_position(Vector2(12 * face, -5))
		fist.init(face, "attack")

func Hook():
	if !attacking and !hooking:
		hooking = true
		fist = fist_scn.instance()
		add_child(fist)
		fist.set_position(Vector2(12 * face, -5))
		fist.init(face, "hook")
	
func FinishAttack():
	attacking = false
	_detach_fist()

func FinishHook():
	hook_hook_return = true
	hooking = false

func _detach_fist():
	fist.queue_free()
	remove_child(fist)
	fist = null

func _draw():
	if fist:
		draw_line(Vector2(12 * face, -5), fist.position,  Color(255, 255, 255), 1)
