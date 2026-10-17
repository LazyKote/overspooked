extends Area2D

@onready var fridge_ui = $"CanvasLayer/Kitchen item inventory"
@export var fridge_inventory : FridgeInventory
@onready var anim = $AnimatedSprite2D
@onready var fridge_open_sound = $FridgeOpenSound
@onready var fridge_closing_sound = $FridgeClosingSound

enum CMState{
	IDLE,
	WORKING
}
var current_state : CMState = CMState.IDLE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fridge_ui.animation_change.connect(on_animation_change)
	
func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		for body in get_overlapping_bodies():
			if body.is_in_group("player"):
				if fridge_ui.visible == false:
					fridge_ui.load_inventory(fridge_inventory)
					fridge_ui.visible = true
					anim.play("working")
					fridge_open_sound.play()
				else:
					fridge_ui.visible = false
					anim.play("default")
				break

func on_animation_change(item):
	InventoryManager.add_item(item)
	anim.play("default")
	fridge_closing_sound.play()
