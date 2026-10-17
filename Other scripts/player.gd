extends CharacterBody2D
@onready var player_animation = $AnimatedSprite2D

const speed = 250.0
var _facing: String = "down"

func get_input():
	var input_dir = Input.get_vector("go_left", "go_right", "go_up", "go_down")
	velocity = input_dir * speed
	_update_animation(input_dir)

func _physics_process(delta):

	get_input()
	move_and_slide()
	
func _update_animation(input_dir: Vector2) -> void:
	if input_dir == Vector2.ZERO:
		player_animation.play("idle_" + _facing)
		return

	if abs(input_dir.x) > abs(input_dir.y):
		_facing = "right" if input_dir.x > 0 else "left"
	else:
		_facing = "down" if input_dir.y > 0 else "up"

	player_animation.play("walking_" + _facing)
