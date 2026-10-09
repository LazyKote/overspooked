extends CharacterBody2D


const speed = 300.0

func get_input():
	var input_dir = Input.get_vector("go_left", "go_right", "go_up", "go_down")
	velocity = input_dir * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
	if Input.is_action_just_pressed("test2"):
		InventoryManager.delete_item()	
	
