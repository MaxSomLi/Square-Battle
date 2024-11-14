extends MeshInstance2D


const HALF = 30
var occupied = "none"
const BORD = 2000
const ROTATION_DIFF = 0.7


func _overlaps_enough(piece) -> bool:
	var x1 = position.x - HALF
	var x2 = position.x + HALF
	var y1 = position.y - HALF
	var y2 = position.y + HALF
	if piece is MeshInstance2D:
		var pr = (piece.scale / 2)
		var x = pr.x
		var y = pr.y
		if piece.rotation != 0:
			x = pr.y
			y = pr.x
		var x1m = piece.position.x - x
		var x2m = piece.position.x + x
		var y1m = piece.position.y - y
		var y2m = piece.position.y + y
		var a = x2m - x1m
		var b = y2m - y1m
		if x1 > x1m:
			a -= x1 - x1m
		if x2 < x2m:
			a -= x2m - x2
		if y1 > y1m:
			b -= y1 - y1m
		if y2 < y2m:
			b -= y2m - y2
		return a > 0 and a*b > BORD
	var meshes = piece.get_children()
	var sum = 0
	for m in meshes:
		var pr = (m.scale / 2)
		var x = pr.x
		var y = pr.y
		if piece.rotation != 0 and abs(piece.rotation - PI) > ROTATION_DIFF:
			x = pr.y
			y = pr.x
		var pos = piece.position + m.position.rotated(piece.rotation)*piece.scale
		var x1m = pos.x - x
		var x2m = pos.x + x
		var y1m = pos.y - y
		var y2m = pos.y + y
		var a = x2m - x1m
		var b = y2m - y1m
		if x1 > x1m:
			a -= x1 - x1m
		if x2 < x2m:
			a -= x2m - x2
		if y1 > y1m:
			b -= y1 - y1m
		if y2 < y2m:
			b -= y2m - y2
		if a > 0 and b > 0:
			sum += a*b
	return sum > BORD
