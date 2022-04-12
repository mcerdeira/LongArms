extends Popup
var hidden = true

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		if !hidden:
			Global.initialize()
			hidden = false
			hide()
			get_tree().reload_current_scene()
	
	if hidden and Global.LIFE <= 0:
		hidden = false
		show()
