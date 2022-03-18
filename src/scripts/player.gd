extends KinematicBody2D

export var gravity = 7
var vspeed = Vector2.ZERO
export var player_speed = 100
export var player_jump_speed = 200

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var moving = false
	
	vspeed.y += gravity
	
	if Input.is_action_pressed("move_left"):
		position.x -= player_speed * delta
		$player_sprite.set_scale(Vector2(-1, 1))
		moving = true
	elif Input.is_action_pressed("move_right"):
		position.x += player_speed * delta
		$player_sprite.set_scale(Vector2(1, 1))
		moving = true
		
	if is_on_floor() and Input.is_action_pressed("jump"):
		vspeed.y = -player_jump_speed
		
	$player_sprite.playing = moving
	
	vspeed = move_and_slide(vspeed, Vector2.UP)
