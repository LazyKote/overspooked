extends Area2D

@onready var fridge_ui = $"../Kitchen item inventory"
var current_item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				if fridge_ui.visible == false:
					fridge_ui.visible = true
				else:
					fridge_ui.visible = false
				break
