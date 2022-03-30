extends Area2D
var item_types = ["food", "money" ]
var item_scn = preload("res://scenes/item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_item_dropper_body_entered(body):
	if body.name == "fist":
		CreateRandomItem()
		queue_free()
		get_parent().remove_child(self)
		
func CreateRandomItem():
	var item = item_scn.instance()
	get_parent().add_child(item)
	item.set_position(position)
	item.initialize(item_types[randi() % item_types.size()])
