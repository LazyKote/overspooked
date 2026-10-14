extends Area2D
@onready var anim = $AnimatedSprite2D
@onready var cooking_timer = $Timer
# Called when the node enters the scene tree for the first time.
enum CMState{
	IDLE,
	WORKING
}
var current_state : CMState = CMState.IDLE
var _pending_item: Item = null
var item: Item = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cooking_timer.timeout.connect(_on_cooking_finished)
	

func _unhandled_input(event):
	if not event.is_action_pressed("interact"):
		return
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			_pending_item = InventoryManager.item_check()
			if _pending_item == null:
				return
			else:
				cooking()
			break
func pause_timer() -> void:
	if current_state == CMState.WORKING:
		cooking_timer.paused = true
		anim.speed_scale = 0.0        # чтобы «working» тоже замер

func resume_timer() -> void:
	if current_state == CMState.WORKING:
		cooking_timer.paused = false
		anim.speed_scale = 1.0
		
func cooking():
	_pending_item = InventoryManager.item_check()
	if _pending_item.can_be_processed == true:
		item = _pending_item.processed_version
		InventoryManager.delete_item()
		on_animation_change()
	else:
		return

func on_animation_change():
	if current_state != CMState.IDLE:
		return
	current_state = CMState.WORKING
	anim.play("working")
	cooking_timer.start()

func _on_cooking_finished() -> void:
	anim.play("default")
	current_state = CMState.IDLE
	InventoryManager.add_item(item)
