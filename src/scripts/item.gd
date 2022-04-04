extends Area2D
var type = "whip"
var grav = 0
var vspeed = Vector2.ZERO

func _ready():
	pass # Replace with function body.

func initialize(_type):
	grav = 100
	type = _type
	$sprite.animation = type
	
func _physics_process(delta):
	if grav != 0:
		position.y += grav * delta

func _on_item_body_entered(body):
	if body.name == "TileMap":
		grav = 0
	elif body.name == "player":
		if type == "whip":
			body.hook_equiped = true
		elif type == "food":
			Global.AddLife(1)
		elif type == "money":
			Global.AddMana()
		
		queue_free()
		get_parent().remove_child(self)
