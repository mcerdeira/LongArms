extends KinematicBody2D
var hit_points = 1
var speed = 180
var rotate_speed = 500
var goto = null
var vspeed = Vector2.ZERO

func _ready():
	pass

func _physics_process(delta):
	if goto:
		vspeed =  goto * speed
		vspeed = move_and_slide(vspeed)
		$sprite.rotation_degrees += rotate_speed * delta
		
func initialize(_player):
	goto = position.direction_to(_player.position)

func detach():
	queue_free()
	get_parent().remove_child(self)

func _on_area_body_entered(body):
	if not "me_name" in body:
		if body.name == "player":
			body.hitted(hit_points)
		
		detach()
