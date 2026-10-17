extends Control
@onready var button_sound = $ButtonSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.





func _on_play_pressed() -> void:
	button_sound.play()
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
	

func _on_exit_pressed() -> void:
	button_sound.play()
	get_tree().quit()


func _on_settings_pressed() -> void:
	button_sound.play()
