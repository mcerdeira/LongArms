extends Popup

func _input(event):
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
		if get_tree().paused:
			show()
		else:
			hide()
