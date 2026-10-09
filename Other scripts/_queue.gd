extends Node2D

@export var customer_scene: PackedScene
@export var path: Path2D

## Точки у стойки, где стоят кассовые слоты (по возрастанию, 0..1).
## Слот 0 — первый, слот 1 — правее, слот 2 — ещё правее и т.д.
@export var counter_ratios: Array[float] = [0.45, 0.55, 0.65]

## Расстояние (в долях пути) между соседними слотами очереди за стойкой.
@export var queue_spacing: float = 0.01

@export var max_customers: int = 6
@export var spawn_interval: float = 6.0
@export var first_spawn_delay: float = 1.5

var customers: Array[PathFollow2D] = []
var _spawn_timer: float

func _ready() -> void:
	assert(customer_scene != null, "customer_scene не назначен")
	assert(path != null, "path не назначен")
	_spawn_timer = first_spawn_delay

func _process(delta: float) -> void:
	_spawn_timer -= delta
	if _spawn_timer <= 0.0 and customers.size() < max_customers:
		_spawn()
		_spawn_timer = spawn_interval

func _spawn() -> void:
	var c: PathFollow2D = customer_scene.instantiate()
	path.add_child(c)

	# Подключаемся к сигналу корня — он есть у customer.tscn
	c.left_cafe.connect(_on_customer_left)

	customers.append(c)
	_assign_slots()

func _on_customer_left(c: PathFollow2D) -> void:
	customers.erase(c)
	_assign_slots()

## Раздать всем текущим посетителям их слоты и целевые точки.
func _assign_slots() -> void:
	for i in customers.size():
		var c := customers[i]
		var at_counter := i < counter_ratios.size()
		var ratio := _slot_ratio(i)
		c.assign_slot(i, ratio, at_counter)

## Куда должен встать слот с номером slot.
func _slot_ratio(slot: int) -> float:
	if slot < counter_ratios.size():
		return counter_ratios[slot]
	# Хвост очереди — позади первого кассового слота, с шагом queue_spacing.
	var offset := (slot - counter_ratios.size() + 1) * queue_spacing
	return max(counter_ratios[0] - offset, 0.0)
