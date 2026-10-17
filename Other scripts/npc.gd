extends Node2D
@onready var npc_ui = $Head/InteractionUi
@onready var interaction_area = $CharacterBody2D/InteractionArea2D
@onready var path = $"../.."
@onready var waiting_timer = $Timer
@onready var waiting_bar  = $Head/TextureProgressBar
@export var all_items_list : AllItemsList

var order
var current_item
signal order_served
var at_counter: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	order = all_items_list.items_list.pick_random()
	waiting_timer.timeout.connect(on_waiting_timer_out)
	waiting_bar.max_value = waiting_timer.wait_time
	waiting_bar.value = waiting_timer.wait_time

func set_at_counter(value: bool) -> void:
	at_counter = value

func _process(_delta: float) -> void:
	if waiting_timer.is_stopped():
		return
	waiting_bar.value = waiting_timer.time_left
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		for body in interaction_area.get_overlapping_bodies():
			if body.is_in_group("player"):
				if npc_ui.visible == false:
					npc_ui.visible = true
					npc_ui.order_ui_refresh(order)
					_start_waiting()
				else:
					current_item = InventoryManager.item_check()
					if current_item != null:
						get_order(current_item)
					else:
						pass
				break

func _start_waiting() -> void:
	waiting_timer.start()
	waiting_bar.max_value = waiting_timer.wait_time
	waiting_bar.value = waiting_timer.wait_time
	waiting_bar.visible = true

func _stop_waiting() -> void:
	waiting_timer.stop()
	waiting_bar.visible = false

func on_waiting_timer_out() -> void:
	_stop_waiting()
	npc_ui.visible = false
	order_served.emit()

func get_order(item) -> void:
	if order == item:
		npc_ui.visible = false
		InventoryManager.delete_item()
		InventoryManager.money_add(item.item_cost)
		_stop_waiting()
		order_served.emit()
