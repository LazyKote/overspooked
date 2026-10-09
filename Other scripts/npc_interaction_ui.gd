extends Control
@onready var item_texture = $SlotTexture/ItemTexture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func order_ui_refresh(order):
	item_texture.texture = order.item_texture
