extends Node
var inventory
var item
signal inventory_changed
signal item_deleted

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory = load("res://Inventory/Inventory_slots.tres")
	item = load("res://Items/Pumpkin_pie.tres")

func add_item():
	inventory.inventory_slots.resize(1)
	inventory.inventory_slots[0] = item
	print(item.item_name)
	emit_signal("inventory_changed")
		
		
func delete_item():
	if inventory.inventory_slots.size() > 0:
		inventory.inventory_slots.remove_at(0)
		emit_signal("item_deleted")
