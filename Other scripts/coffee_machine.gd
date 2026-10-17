extends Area2D
@onready var coffee_machine_ui = $"CanvasLayer/Kitchen item inventory"
@onready var anim = $AnimatedSprite2D
@onready var brew_timer = $Timer
@onready var ghost  = $Ghost
var _is_lit: bool = false

@export var coffee_machine_inventory : FridgeInventory

enum CMState{
	IDLE,
	WORKING,
	READY
}
var current_state : CMState = CMState.IDLE
var _pending_item: Item = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coffee_machine_ui.animation_change.connect(on_animation_change)
	brew_timer.timeout.connect(_on_brew_finished)
	

func _unhandled_input(event):
	if not event.is_action_pressed("interact"):
		return
	for body in get_overlapping_bodies():
		if not body.is_in_group("player"):
			continue

# Игрок подошёл к машине с готовым кофе — забираем.
		if current_state == CMState.READY:
			_collect_drink()
			break

# Иначе — обычное открытие/закрытие UI, но только когда машина IDLE.
		if current_state == CMState.IDLE:
			coffee_machine_ui.visible = not coffee_machine_ui.visible
			if coffee_machine_ui.visible:
				coffee_machine_ui.load_inventory(coffee_machine_inventory)
		break

func pause_timer() -> void:
	_is_lit = true
	ghost.play("scared")
	if current_state == CMState.WORKING:
		brew_timer.paused = true
		anim.speed_scale = 0.0        # чтобы «working» тоже замер

func resume_timer() -> void:
	_is_lit = false
	ghost.play("default")
	if current_state == CMState.WORKING:
		brew_timer.paused = false
		anim.speed_scale = 1.0

func on_animation_change(item):
	if current_state != CMState.IDLE:
		return
	_pending_item = item
	current_state = CMState.WORKING
	anim.play("working")
	if _is_lit:
		brew_timer.start()
		brew_timer.paused = true
		anim.speed_scale = 0.0
	else:
		brew_timer.start()

func _on_brew_finished() -> void:
	current_state = CMState.READY
	
func _collect_drink() -> void:
	if _pending_item == null:
		return
	InventoryManager.add_item(_pending_item)
	_pending_item = null
	current_state = CMState.IDLE
	anim.play("default")
