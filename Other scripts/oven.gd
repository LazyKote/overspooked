extends Area2D
@onready var anim = $AnimatedSprite2D
@onready var cooking_timer = $Timer
@onready var cooking_ui = $CanvasLayer/TextureRect
@onready var ghost = $Ghost
@onready var oven_sound = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
enum CMState{
	IDLE,
	WORKING,
	READY
}
var current_state : CMState = CMState.IDLE
var _pending_item: Item = null 
var _result_item: Item = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cooking_timer.timeout.connect(_on_cooking_finished)
	

func _unhandled_input(event):
	if not event.is_action_pressed("interact"):
		return
	for body in get_overlapping_bodies():
		if body.is_in_group("player"):
			match current_state:
				CMState.READY:
					_collect_item()
				CMState.IDLE:
					_try_start_cooking()
				CMState.WORKING:
					pass
			break

func pause_timer() -> void:
	ghost.play("scared")
	if current_state == CMState.WORKING:
		cooking_timer.paused = true
		anim.speed_scale = 0.0 

func resume_timer() -> void:
	ghost.play("default")
	if current_state == CMState.WORKING:
		cooking_timer.paused = false
		anim.speed_scale = 1.0
		
func _try_start_cooking() -> void:
	var ingredient = InventoryManager.item_check()
	if ingredient == null or not ingredient.can_be_processed:
		return
	_pending_item = ingredient
	_result_item = ingredient.processed_version
	InventoryManager.delete_item()
	_start_cooking()

func _start_cooking() -> void:
	current_state = CMState.WORKING
	anim.play("working")
	oven_sound.play()
	cooking_timer.start()

func _collect_item() -> void:
	if _result_item == null:
		return
	InventoryManager.add_item(_result_item)
	_result_item = null
	current_state = CMState.IDLE
	anim.play("default")
	cooking_ui.visible = false

func _on_cooking_finished() -> void:
	current_state = CMState.READY
	cooking_ui.visible = true 
	_pending_item = null
