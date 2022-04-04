extends Sprite

func _process(delta):
	resize_bar()

func resize_bar():
	scale = Vector2(Global.MANA / Global.TOTAL_MANA, 1)
