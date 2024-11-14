extends Node2D

@onready var text = $/root/Main/Label
var QM = QuadMesh.new()
const NUM = 14
const TOTAL = NUM*NUM
const SIZE_S = 55
const SIZE_L = 60
const START = -390
var quads = []
var move_count = 0
var MAX = 2
var mat = load("res://yellow.tres")
@onready var pieces = [$/root/Main/Type19, $/root/Main/Type21, $/root/Main/Type20, $/root/Main/Type18, $/root/Main/Type17, $/root/Main/Type10, $/root/Main/Type16, $/root/Main/Type15, $/root/Main/Type14, $/root/Main/Type13, $/root/Main/Type12, $/root/Main/Type11, $/root/Main/Type7, $/root/Main/Type8, $/root/Main/Type9, $/root/Main/Type6, $/root/Main/Type5, $/root/Main/Type4, $/root/Main/Type3, $/root/Main/Type2, $/root/Main/Type1]
const SC = [1, -1]
const ROT = [0, 0.5*PI, PI, 1.5*PI]
const STEP = 30
const STEP_COUNT = 26
const OPP = "yellow"
const C = TOTAL - NUM
var pieces_size = 21



func _ready() -> void:
	QM.size = Vector2(SIZE_S, SIZE_S)
	for i in range(TOTAL):
		var tile = MeshInstance2D.new()
		tile.mesh = QM
		@warning_ignore("integer_division")
		tile.position = Vector2(START + (i / NUM)*SIZE_L, START + (i % NUM)*SIZE_L)
		tile.z_index = -1
		add_child(tile)
		tile.set_script(load("res://field.gd"))
		quads.append(tile)

func _tiles_free(color: String, arr: Array, c: int) -> bool:
	for i in arr:
		if quads[i].occupied != "none":
			return false
		var x = i / NUM
		var y = i % NUM
		if x > 0 and quads[i - NUM].occupied == color:
			return false
		if x < NUM - 1 and quads[i + NUM].occupied == color:
			return false
		if y > 0 and quads[i - 1].occupied == color:
			return false
		if y < NUM - 1 and quads[i + 1].occupied == color:
			return false
	for i in arr:
		var x = i / NUM
		var y = i % NUM
		if x > 0 and y > 0 and quads[i - NUM - 1].occupied == color:
			return true
		if x < NUM - 1 and y < NUM - 1 and quads[i + NUM + 1].occupied == color:
			return true
		if x < NUM - 1 and y > 0 and quads[i + NUM - 1].occupied == color:
			return true
		if x > 0 and y < NUM - 1 and quads[i - NUM + 1].occupied == color:
			return true
	return c in arr

func _process(_delta: float) -> void:
	if move_count == MAX:
		var left = MAX
		var i = 0
		while i < pieces_size and left > 0:
			var do = true
			var piece = pieces[i].duplicate()
			piece.visible = false
			piece.set_script(null)
			var ch = piece.get_children()
			var SIZE
			for c in ch:
				if c is Area2D:
					SIZE = c.SIZE
					c.set_script(null)
			for r in ROT:
				if do:
					piece.rotation = r
					for s in SC:
						if do:
							piece.scale.x = s
							for j in range(STEP_COUNT):
								for k in range(STEP_COUNT):
									if do:
										piece.position = Vector2(START + j*STEP, START + k*STEP)
										var col = []
										for p in range(TOTAL):
											if quads[p]._overlaps_enough(piece):
												col.append(p)
										if col.size() == SIZE and _tiles_free(OPP, col, C):
											for q in col:
												quads[q].texture = mat
												quads[q].occupied = OPP
											pieces.remove_at(i)
											do = false
											i = -1
											left -= 1
											pieces_size -= 1
											var lines = text.text.split("\n")
											text.text = lines[0] + "\n" + "OPPONENT: " + str(int(lines[1]) + SIZE)
			i += 1
		move_count = 0
