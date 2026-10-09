extends Node2D
@onready var npc_ui = $Head/InteractionUi
@onready var interaction_area = $CharacterBody2D/InteractionArea2D
@onready var path = $"../.."
@export var all_items_list : AllItemsList
var order
var current_item
signal order_served
var at_counter: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	order = all_items_list.items_list.pick_random()

func set_at_counter(value: bool) -> void:
	at_counter = value
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		for body in interaction_area.get_overlapping_bodies():
			if body.is_in_group("player"):
				if npc_ui.visible == false:
					npc_ui.visible = true
					npc_ui.order_ui_refresh(order)
				else:
					current_item = InventoryManager.item_check()
					if current_item != null:
						get_order(current_item)
					else:
						pass
				break

func get_order(item):
	if order == item:
		npc_ui.visible = false
		InventoryManager.delete_item()
		InventoryManager.money_add(item.item_cost)
		order_served.emit()
	else:
		pass
