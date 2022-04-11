extends Popup
var hidden = true

func _process(delta):
	if hidden and Global.LIFE <= 0:
		hidden = false
		show()
