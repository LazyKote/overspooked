extends PathFollow2D

signal left_cafe(customer)

@export var walk_speed: float = 80.0

var queue_slot: int = -1
var target_ratio: float = 0.0
var is_at_counter: bool = false
var is_leaving: bool = false

@onready var npc: Node2D = $npc
var _path_length: float

func _ready() -> void:
	_path_length = (get_parent() as Path2D).curve.get_baked_length()
	progress_ratio = 0.0
	npc.order_served.connect(_start_leaving)

func assign_slot(slot: int, target: float, at_counter: bool) -> void:
	queue_slot = slot
	target_ratio = target
	is_at_counter = at_counter
	npc.set_at_counter(at_counter and not is_leaving)


func _process(delta: float) -> void:
	if is_leaving:
		_move_toward(1.0, delta)
		if progress_ratio >= 0.999:
			left_cafe.emit(self)
			queue_free()
		return
	if abs(progress_ratio - target_ratio) > 0.001:
		_move_toward(target_ratio, delta)

func _move_toward(target: float, delta: float) -> void:
	progress = clamp(
		move_toward(progress, target * _path_length, walk_speed * delta),
		0.0, _path_length
	)

func _start_leaving() -> void:
	is_leaving = true
	is_at_counter = false
	npc.set_at_counter(false)
