extends Area2D

@onready var fridge_ui = $"CanvasLayer/Kitchen item inventory"
@export var fridge_inventory : FridgeInventory
@onready var anim = $AnimatedSprite2D

enum CMState{
	IDLE,
	WORKING
}
var current_state : CMState = CMState.IDLE
var _pending_item: Item = null

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
				else:
					fridge_ui.visible = false
				break

func on_animation_change(item):
	if current_state != CMState.IDLE:
		return
	_pending_item = item
	current_state = CMState.WORKING
	anim.play("working")
	InventoryManager.add_item(_pending_item)
