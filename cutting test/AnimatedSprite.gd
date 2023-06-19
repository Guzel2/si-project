extends AnimatedSprite

var time = 0
var total_time = 1

var cut_angle = 20
var cut_y_offset = 10

#func _process(delta):
#	time += delta
#	if time > total_time:
#		cut_in_half()
#		set_process(false)

func _ready():
	cut_in_half()

func cut_in_half():
	print('cut')
	var texture
	texture = frames.get_frame(animation, 0)
	
	var size = texture.get_size()
	
	var cut_offset = cut_angle / 45.0 * (size.y / 2)
	
	var left_cut_point = Vector2(0, size.y/2 + cut_offset + cut_y_offset)
	var right_cut_point = Vector2(size.x, size.y/2 - cut_offset + cut_y_offset)
	
	var top_points = [Vector2(0, 0), left_cut_point, right_cut_point, Vector2(size.x, 0)]
	var bot_points = [left_cut_point, Vector2(0, size.y), size, right_cut_point]
	
	var top_shard = Polygon2D.new()
	top_shard.polygon = top_points
	top_shard.texture = texture
	add_child(top_shard)
	
	var bot_shard = Polygon2D.new()
	bot_shard.polygon = bot_points
	bot_shard.texture = texture
	add_child(bot_shard)

