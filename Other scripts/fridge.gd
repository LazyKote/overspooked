extends Area2D

var fridge_inv

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _unhandled_input(event):
	if event.is_action_pressed("test"):
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				InventoryManager.add_item()
				break
