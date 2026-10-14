extends Node2D

@export var customer_scene: PackedScene
@export var path: Path2D

## Слоты у стойки (три кассовых места).
@export var counter_ratios: Array[float] = [0.45, 0.55, 0.65]
@export var queue_spacing: float = 0.01

## Максимум посетителей ОДНОВРЕМЕННО в сцене (включая тех, кто у стойки).
@export var max_in_queue: int = 3

## Максимум посетителей ЗА ВСЮ сессию (после — спавн прекращается).
@export var total_customers: int = 20

@export var spawn_interval: float = 6.0
@export var first_spawn_delay: float = 1.5

var customers: Array[PathFollow2D] = []
var _spawn_timer: float
var _spawned_total: int = 0

func _ready() -> void:
	assert(customer_scene != null, "customer_scene не назначен")
	assert(path != null, "path не назначен")
	_spawn_timer = first_spawn_delay

func _process(delta: float) -> void:
	# Уже выпустили всех — больше не спавним.
	if _spawned_total >= total_customers:
		return

	# Очередь полна — ждём, пока кто-то уйдёт.
	if customers.size() >= max_in_queue:
		return

	_spawn_timer -= delta
	if _spawn_timer <= 0.0:
		_spawn()
		_spawn_timer = spawn_interval

func _spawn() -> void:
	var c: PathFollow2D = customer_scene.instantiate()
	path.add_child(c)
	c.left_cafe.connect(_on_customer_left)
	customers.append(c)
	_spawned_total += 1
	_assign_slots()

func _on_customer_left(c: PathFollow2D) -> void:
	customers.erase(c)
	_assign_slots()

func _assign_slots() -> void:
	for i in customers.size():
		var c := customers[i]
		var at_counter := i < counter_ratios.size()
		var ratio := _slot_ratio(i)
		c.assign_slot(i, ratio, at_counter)

func _slot_ratio(slot: int) -> float:
	if slot < counter_ratios.size():
		return counter_ratios[slot]
	var offset := (slot - counter_ratios.size() + 1) * queue_spacing
	return max(counter_ratios[0] - offset, 0.0)
