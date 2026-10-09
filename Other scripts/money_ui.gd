extends Control
@onready var money_label = $TextureRect/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryManager.money_changed.connect(on_money_changed)

func on_money_changed(money):
	money_label.text = str(money)
