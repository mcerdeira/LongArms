extends Area2D
var on = false

func _ready():
	pass # Replace with function body.

func _on_check_point_body_entered(body):
	if !on and not "me_name" in body:
		if body.name == "player":
			on = true
			$sprite.animation = "on"
			$sprite.playing = true
			Global.LAST_CHECKPOINT = body.position
