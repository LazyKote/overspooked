extends Control

@export var fridge_inv: FridgeInventory

@onready var grid: GridContainer = $GridContainer

var _slots: Array[TextureRect] = []
var _buttons: Array[TextureButton] = []

func _ready() -> void:
	_collect_slots()

	for i in _buttons.size():
		_buttons[i].pressed.connect(_on_slot_pressed.bind(i))

	if fridge_inv:
		fridge_inv.changed.connect(refresh)

	refresh()

func _collect_slots() -> void:
	for child in grid.get_children():
		if child is TextureRect:
			var btn := child.get_node_or_null("TextureButton") as TextureButton
			if btn:
				_slots.append(child)
				_buttons.append(btn)

func refresh() -> void:
	var items: Array = fridge_inv.fridge_inventory 

	for i in _slots.size():
		var slot := _slots[i]
		var btn := _buttons[i]

		if i < items.size() and items[i] != null:
			btn.texture_normal = items[i].item_texture 
			slot.visible = true
			btn.disabled = false


func _on_slot_pressed(index: int) -> void:
	if fridge_inv == null:
		return
	var item = fridge_inv.fridge_inventory[index]
	if item == null:
		return
	InventoryManager.add_item(item)
