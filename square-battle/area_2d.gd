extends Area2D



@onready var main = $/root/Main
@onready var text = $/root/Main/Label
@onready var NUM = main.NUM
@onready var TOTAL = main.TOTAL
@onready var piece = get_parent()
@onready var QUADS = main.quads
var place_helper
const SAME = "blue"
@onready var POS = piece.position
@export var SIZE = 5
const ROTATION_DIFF = 0.7
@onready var mat = load("res://cyan.tres")



func _click(_vp, event: InputEvent, _shape_idx) -> void:
	if main.move_count < main.MAX and event is InputEventMouseButton and event.pressed and !piece.is_placed and event.button_index == MOUSE_BUTTON_MIDDLE:
		piece.scale.x *= -1
	if main.move_count < main.MAX and event is InputEventMouseButton and event.pressed and !piece.is_placed and event.button_index == MOUSE_BUTTON_RIGHT:
		if piece.rotation == 0:
			piece.rotation = 0.5*PI
		elif abs(piece.rotation - 0.5*PI) < ROTATION_DIFF:
			piece.rotation = PI
		elif abs(piece.rotation - PI) < ROTATION_DIFF:
			piece.rotation = 1.5*PI
		else:
			piece.rotation = 0
	if main.move_count < main.MAX and event is InputEventMouseButton and event.pressed and !piece.is_placed and event.button_index == MOUSE_BUTTON_LEFT:
		piece.is_dragged = true
	if main.move_count < main.MAX and event is InputEventMouseButton and event.is_released() and !piece.is_placed:
		piece.is_dragged = false
		place_helper = _can_place_here()
		if place_helper[0]:
			piece.is_placed = true
			piece.visible = false
			main.move_count += 1
			for i in range(SIZE):
				QUADS[place_helper[1][i]].occupied = SAME
				QUADS[place_helper[1][i]].texture = mat
			var lines = text.text.split("\n")
			text.text = "YOU: " + str(int(lines[0]) + SIZE) + "\n" + lines[1]
		else:
			piece.position = POS

func _process(_delta: float) -> void:
	if piece.is_dragged:
		piece.position = get_global_mouse_position()

func _can_place_here() -> Array:
	var col = []
	for i in range(TOTAL):
		if QUADS[i]._overlaps_enough(piece):
			col.append(i)
	if col.size() != SIZE or !main._tiles_free(SAME, col, NUM - 1):
		return [false]
	return [true, col]
