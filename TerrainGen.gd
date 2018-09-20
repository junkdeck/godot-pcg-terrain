extends Node2D

var update_interval = 1
var update_timer = update_interval

func _draw():
	var terrain_res = 100
	var terrain_step = 5
	var terrain_variation = 5.0
	var baseline = Vector2(0.0, 250.0)
	var points = PoolVector2Array()
	
	var col = CollisionShape2D.new()
	var poly = CollisionPolygon2D.new()
	
	points.push_back(baseline)
	
	for i in range(terrain_res+1):
		randomize()
		var terrain_jump = 10.0 if randf() * 100.0 + 1.0 > 95 else 1
		
		var last_point = points[i]
		var point = Vector2(i * (terrain_step), last_point.y + (randf()*2-1) * (terrain_variation * terrain_jump))
		
		points.push_back(point)
	
	for point in range(terrain_res):
		draw_line(points[point], points[point+1], Color(1.0,0.0,0.0))
	
	# close bounding polygon
	points.append_array([points[points.size()-1] + Vector2(0.0, 1000.0), Vector2(points[0].x, 1000)])
	
	poly.polygon = points
	col.shape = poly
	
	for child in get_children():
		child.queue_free()
		
	self.add_child(poly)


func _process(delta):
	if(update_timer <= 0):
		update()
		update_timer = update_interval
	update_timer -= delta