extends Node
var inventory
var item
signal inventory_changed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory = load("res://Inventory/Inventory_slots.tres")
	item = load("res://Items/Pumpkin_pie.tres")

func add_item():
	inventory.inventory_slots = item
	print(item.item_name)
		
		
func delete_item():
	pass
