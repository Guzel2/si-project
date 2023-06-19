extends Polygon2D

var time = 0
var total_time = 1

func _process(delta):
	time += delta
	if time > total_time:
		cut_in_half()
		set_process(false)

func cut_in_half():
	var points = polygon
	
	var delauny_points = Geometry.triangulate_delaunay_2d(points)
	
	print(delauny_points)
	
	for index in len(delauny_points) / 3:
		var new_poly_points = PoolVector2Array()
		
		for n in range(3):
			new_poly_points.append(points[delauny_points[(index * 3) + n]])
		
		print(new_poly_points)
		
		var shard = Polygon2D.new()
		
		shard.polygon = new_poly_points
		shard.texture = texture
		
		shard.position.x = (index + 1) * 96
		
		add_child(shard)
		
