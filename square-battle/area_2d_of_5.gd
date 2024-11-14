extends "res://area_2d.gd"



func _ready() -> void:
	connect("input_event", Callable(self, "_click"))
	SIZE = 5
