extends Node
var inventory
var money = 0

signal inventory_changed
signal item_deleted
signal money_changed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory = load("res://Inventory/Inventory_slots.tres")

func add_item(item):
	inventory.inventory_slots.resize(1)
	inventory.inventory_slots[0] = item
	emit_signal("inventory_changed")
			
func delete_item():
	if inventory.inventory_slots.size() > 0:
		inventory.inventory_slots.remove_at(0)
		emit_signal("item_deleted")
		
func item_check():
	var current_item = 	inventory.inventory_slots[0]
	return(current_item)

func money_add(money_added):
	money+=money_added
	money_changed.emit(money)
