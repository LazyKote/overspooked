extends Control

var inventory
@onready var item_texture = $MarginContainer/VBoxContainer/Inventory_slot/Item_texture
@onready var item_label = $MarginContainer/VBoxContainer/Item_name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryManager.inventory_changed.connect(on_inventory_changed)
	InventoryManager.item_deleted.connect(on_item_deleted)
	inventory = load("res://Inventory/Inventory_slots.tres")
	
func on_inventory_changed() -> void:
	item_label.text = inventory.inventory_slots[0].item_name
	item_texture.texture = inventory.inventory_slots[0].item_texture
	
func on_item_deleted() -> void:
	item_label.text ="Nothing"
	item_texture.texture = null
