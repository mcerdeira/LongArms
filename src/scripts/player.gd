extends KinematicBody2D

export var gravity = 7
var vspeed = Vector2.ZERO
var fist = null
var fist_scn = preload("res://scenes/fist.tscn")
var face = 1

var goto_hoook = false
var goto_hook_pos = null
var goto_hook_face = 0

export var player_speed = 150
export var player_jump_speed = 250
export var attacking = false
export var hooking = false
export var jumping = false

func _ready():
	pass

func _physics_process(delta):
	var moving = false
	if goto_hoook:
		vspeed.x += (player_speed * 10 * delta) * goto_hook_face
		if goto_hook_face == 1:
			vspeed = move_and_slide(vspeed, Vector2.RIGHT)
		else:
			vspeed = move_and_slide(vspeed, Vector2.LEFT)
		
		$player_sprite.set_scale(Vector2(goto_hook_face, 1))
		$player_sprite.animation = "hooking"
		update()
		
		if position.distance_to(fist.position) <= 20:
			vspeed = Vector2.ZERO
			FinishHook()
			ReverseJump(delta)
		
	else: 
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
			vspeed = Vector2.ZERO
			Attack()
		
		if Input.is_action_pressed("hook"):
			vspeed = Vector2.ZERO
			Hook()
			
		if jumping and is_on_floor():
			jumping = false
		
		if !attacking and !hooking and is_on_floor() and Input.is_action_pressed("jump"):
			Jump()
		
		if jumping:
			$player_sprite.animation = "jumping"
		elif moving:
			$player_sprite.animation = "walking"
		else:
			$player_sprite.animation = "default"

		if attacking:
			vspeed = Vector2.ZERO
			$player_sprite.animation = "attackhook"
			update()
		elif hooking:
			vspeed = Vector2.ZERO
			$player_sprite.animation = "attackhook"
			update()
				
		$player_sprite.playing = moving
		
		vspeed.y += gravity
		vspeed = move_and_slide(vspeed, Vector2.UP)

func Attack():
	if !attacking and !hooking:
		attacking = true
		fist = fist_scn.instance()
		get_parent().add_child(fist)
		fist.set_position(Vector2(position.x + 12 * face, position.y - 5))
		fist.init(face, "attack", self)

func Hook():
	if !attacking and !hooking:
		hooking = true
		fist = fist_scn.instance()
		get_parent().add_child(fist)
		fist.set_position(Vector2(position.x + 12 * face, position.y - 5))
		fist.init(face, "hook", self)
	
func ReverseJump(delta):
	Jump()
	face *= -1
	position.x += (player_speed * delta) * face
	$player_sprite.set_scale(Vector2(face, 1))
	
func Jump():
	jumping = true
	vspeed.y = -player_jump_speed
	
func FinishAttack():
	attacking = false
	_detach_fist()

func FinishHook():
	hooking = false
	goto_hoook = false
	_detach_fist()

func GotoHook(_face, _position):
	goto_hoook = true
	goto_hook_face = _face

func _detach_fist():
	fist.queue_free()
	get_parent().remove_child(fist)
	fist = null

func _draw():
	if fist:
		draw_line(Vector2(12 * face, -5), to_local(fist.position),  Color(255, 255, 255), 1)
