extends Node2D

@onready var detection_area: Area2D = $DetectionArea

func _ready() -> void:
	detection_area.area_entered.connect(_on_area_entered)
	detection_area.area_exited.connect(_on_area_exited)

func _process(_delta: float) -> void:
	# Направление на мышь
	var mouse := get_global_mouse_position()
	var dir := mouse - global_position
	global_rotation = dir.angle()

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("pause_timer"):
		area.pause_timer()

func _on_area_exited(area: Area2D) -> void:
	if area.has_method("resume_timer"):
		area.resume_timer()
