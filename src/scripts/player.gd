extends KinematicBody2D

export var gravity = 7
var vspeed = Vector2.ZERO
var fist = null
var fist_scn = preload("res://scenes/fist.tscn")
var burst_scn = preload("res://scenes/burst.tscn")
var face = 1
var fist_initial = Vector2.ZERO

var hook_equiped = true

var goto_hoook = false
var goto_hook_pos = null
var goto_hook_face = 0
var flag_direction = ""
var stomp_timer = 0

export var player_speed = 150
export var player_jump_speed = 250
export var attacking = false
export var hooking = false
export var jumping = false
export var stomping = 0

func _ready():
	pass

func _physics_process(delta):
	var moving = false
	if stomping > 0:
		stomp_timer -= 1 * delta
		stomping -= 1 * delta
		$player_sprite.animation = "stomp"
		if stomp_timer > 0:
			$Camera2D.shake(delta, 0.1)
		elif stomp_timer <= 0:
			$Camera2D.default()
		
	elif goto_hoook:
		if flag_direction == "":
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
		elif flag_direction == "up":
			vspeed.y -= (player_speed * 10 * delta)
			vspeed = move_and_slide(vspeed, Vector2.UP)
			$player_sprite.animation = "hooking_up"
			update()
			
			if position.distance_to(fist.position) <= 20:
				vspeed = Vector2.ZERO
				FinishHook()
				
		elif flag_direction == "down":
			vspeed.y += (player_speed * 10 * delta)
			vspeed = move_and_slide(vspeed, Vector2.DOWN)
			$player_sprite.animation = "hooking_down"
			update()
			
			if position.distance_to(fist.position) <= 20:
				vspeed = Vector2.ZERO
				FinishHook()
				Stomp()
		
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
			
		if hook_equiped and Input.is_action_pressed("attack"):
			vspeed = Vector2.ZERO
			Attack()
		
		if hook_equiped and Input.is_action_pressed("hook"):
			vspeed = Vector2.ZERO
			Hook()
			
		if jumping and is_on_floor():
			jumping = false
		
		if !attacking and !hooking and is_on_floor() and Input.is_action_pressed("jump"):
			Jump()
		
		if jumping or !is_on_floor():
			$player_sprite.animation = "jumping"
		elif moving:
			$player_sprite.animation = "walking"
		else:
			$player_sprite.animation = "default"

		if attacking:
			vspeed = Vector2.ZERO
			$player_sprite.animation = "attackhook"
			if flag_direction == "up":
				$player_sprite.set_scale(Vector2(1, 1))
				$player_sprite.animation = "attackhook_up"
			if flag_direction == "down":
				$player_sprite.animation = "attackhook_down"
			
			update()
		elif hooking:
			vspeed = Vector2.ZERO
			$player_sprite.animation = "attackhook"
			if flag_direction == "up":
				$player_sprite.set_scale(Vector2(1, 1))
				$player_sprite.animation = "attackhook_up"
			if flag_direction == "down":
				$player_sprite.animation = "attackhook_down"
				
			update()
				
		$player_sprite.playing = moving
		
		vspeed.y += gravity
		vspeed = move_and_slide(vspeed, Vector2.UP)

func Attack():
	if !attacking and !hooking:
		FlagDirection()
		attacking = true
		fist = fist_scn.instance()
		get_parent().add_child(fist)
		var pos = Vector2(position.x + 12 * face, position.y - 5)
		fist_initial = Vector2(12 * face, -5)
		if flag_direction == "up":
			fist_initial = Vector2(0, -21)
			pos = Vector2(position.x, position.y - 21)
		if flag_direction == "down":
			fist_initial = Vector2(9 * face, 13)
			pos = Vector2(position.x + (9 * face), position.y + 13)
		
		fist.set_position(pos)
		fist.init(face, "attack", self, flag_direction)

func Hook():
	if !attacking and !hooking:
		FlagDirection()
		hooking = true
		fist = fist_scn.instance()
		get_parent().add_child(fist)
		var pos = Vector2(position.x + 12 * face, position.y - 5)
		fist_initial = Vector2(12 * face, -5)
		if flag_direction == "up":
			fist_initial = Vector2(0, -21)
			pos = Vector2(position.x, position.y - 21)
		if flag_direction == "down":
			fist_initial = Vector2(9 * face, 13)
			pos = Vector2(position.x + (9 * face), position.y + 13)
		
		fist.set_position(pos)
		fist.init(face, "hook", self, flag_direction)

func FlagDirection():
	flag_direction = ""
	if Input.is_action_pressed("move_up"):
		flag_direction = "up"
		
	if jumping and Input.is_action_pressed("move_down"):
		flag_direction = "down"

func Stomp():
	stomp_timer = 0.5
	stomping = 2
	var pos1 = Vector2(position.x + 16, position.y + 7)
	var pos2 = Vector2(position.x - 16, position.y + 7)
	
	var burst = burst_scn.instance()
	get_parent().add_child(burst)
	burst.initialize(1)
	burst.set_position(pos1)
	
	burst = burst_scn.instance()
	get_parent().add_child(burst)
	burst.initialize(-1)
	burst.set_position(pos2)

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
	if flag_direction != "":
		$player_sprite.set_scale(Vector2(face, 1))
	_detach_fist()

func FinishHook():
	hooking = false
	goto_hoook = false
	if flag_direction != "down":
		$player_sprite.set_scale(Vector2(face, 1))
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
		draw_line(fist_initial, to_local(fist.position),  Color(255, 255, 255), 1)
