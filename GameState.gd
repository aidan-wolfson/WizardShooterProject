extends Node
class_name GameState

signal Transition #signal from either GameState to swap states

func Enter():
	pass
	
func Exit():
	pass
	
func Update(delta):
	pass

## The following functions use ray tracing to calculate if the Player's Vector2
## is outside of the bounds described by the translated vectors in PackedVector2Array
## I kind of understand the logic, but the implementation is modified generic
## ray tracing code. 
func is_player_outside_map(p: Vector2, vertices: PackedVector2Array) -> bool:
	var cross_count = 0
	var n = vertices.size()

	for i in range(n):
		var start_point = vertices[i]
		var end_point = vertices[(i + 1) % n]  # Wraps around to the first vertex

		if is_ray_crossing_line(p, start_point, end_point):
			cross_count += 1

	return cross_count % 2 == 1

func is_ray_crossing_line(p: Vector2, a: Vector2, b: Vector2) -> bool:
	if a.y > b.y:
		var temp = a
		a = b
		b = temp
	
	if p.y == a.y or p.y == b.y:
		p.y += 0.0001  # Shift the point slightly to avoid collinearity

	if p.y > b.y or p.y < a.y:
		return false

	if p.x > max(a.x, b.x):
		return false

	if p.x < min(a.x, b.x):
		return true

	if a.x == b.x:  # Vertical line
		return true

	# Compute slope of the line
	var m = (b.y - a.y) / (b.x - a.x)
	# Find the y-intercept for the line
	var expected_y = m * (p.x - a.x) + a.y
	return p.y <= expected_y

