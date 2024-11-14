extends Button

@onready var main = get_parent()


func _on_pressed() -> void:
	main.move_count = 2
