extends Sprite

func _process(delta):
	resize_bar()

func resize_bar():
	scale = Vector2(Global.LIFE / Global.TOTAL_LIFE, 1)
