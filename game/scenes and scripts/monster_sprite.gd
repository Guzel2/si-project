extends AnimatedSprite

var should_move = false

var phase = -1
var timer = 0

var list_of_animations = [
	'apple', 'bus', 'cheese', 'chopsticks', 'cookie', 
	'dog', 'fork', 'japan', 'juice', 'milk', 'ramen', 
	'soccer', 'spoon', 'stamp', 'taxi', 'umbrella', 
	'one', 'two', 'three', 'four', 'five', 'six', 
	'seven', 'eight', 'nine', 'ten', 'zero', 'black', 
	'white', 'yellow', 'brown', 'blue', 'green', 'red', 
	'orange', 'pink', 'book', 'dragon', 'television', 
	'knife', 'beer', 'flower', 'mushroom', 'notebook', 
	'sushi', 'airconditioner', 'dango', 'golf', 'pen', 
	'plane', 'peach', 'samurai', 'ship', 'blowfish', 
	'sumo', 'telephone', 'baseball', 'bowling', 'bread', 
	'guitar', 'car', 'mobilephone', 'tennis', 'tie', 
	'tempura', 'yakitori', 'clock', 'house', 'train', 'yen',
	'shoe', 't-shirt', 'tabel', 'coffee', 'computer', 'manga',
	'tea', 'trousers', 'newspaper', 'key', #all after line 23 are not in sprites
	'basketball', 'kendo', 'onigiri', 'radio', 'spider',
	'camera', 'chair', 'dress', 'matches', 'suit',
	'bicycle', 'cat', 'centipede', 'mantis', 'mochi',
	'motorcycle', 'temple_gate', 'toilet', 'video_game', 'violin' 
	]

var mode
var question

#func _ready():
#	print((frames.get_animation_names()))

func _ready():
	randomize()
	list_of_animations.shuffle()
	
	match mode:
		'hira':
			animation = list_of_animations[0]
		'kata':
			animation = list_of_animations[0]
		'vocab_english':
			animation = question
		'vocab_japanese':
			animation = question

func _process(delta):
	if should_move:
		if set_position_to(Vector2(450, 400), 8):
			should_move = false
	
	match phase:
		-1: #wait for start
			timer += delta
			if timer >= .4:
				phase = 0
				should_move = true
		0: #idle
			pass
		1: #start timer
			timer = 0
			phase = 2
		2: #wait  sec
			timer += delta
			if timer >= .15:
				phase = 3
				should_move = false
		3: #fade away
			cut_in_half()
			phase = 9
			
			#var should_die = true
			
			#if !set_modulate_to(Color(1, 1, 1, 0), 5):
			#	should_die = false
			#if !set_scale_to(Vector2(1.25, .75), 20):
			#	should_die = false
			#if !set_position_to(Vector2(430, 400), 10):
			#	should_die = false
			
			#if should_die:
			#	phase = 9
		
		4: #flee start up
			should_move = false
			var next_phase = true
			
			if !set_scale_to(Vector2(1.2, .88), 8):
				next_phase = false
				print('sca')
			if !set_position_to(Vector2(465, 400), 9):
				next_phase = false
				print('pos')
			
			if next_phase:
				print('next_phase')
				phase = 5
		
		5: #flee start up
			var should_die = true
			
			if !set_modulate_to(Color(1, 1, 1, 0), 14):
				should_die = false
			if !set_scale_to(Vector2(.7, 1.35), 20):
				should_die = false
			if !set_position_to(Vector2(400, -350), 18):
				should_die = false
			
			if should_die:
				phase = 9
		
		
		9: #die
			queue_free()

func cut_in_half():
	var cut_angle = 10 + (randi() % 26)
	var cut_y_offset = -10 + (randi() % 21)
	
	var texture = frames.get_frame(animation, 0)
	var size = texture.get_size()
	print(size * scale)
	var cut_offset = cut_angle / 45.0 * (size.y / 2)
	
	var left_cut_point = Vector2(0, size.y/2 + cut_offset + cut_y_offset)
	var right_cut_point = Vector2(size.x, size.y/2 - cut_offset + cut_y_offset)
	
	var top_points = [Vector2(0, 0), left_cut_point, right_cut_point, Vector2(size.x, 0)]
	var bot_points = [left_cut_point, Vector2(0, size.y), size, right_cut_point]
	
	var top_shard = load("res://scenes and scripts/monster_polygon.tscn").instance()
	top_shard.polygon = top_points
	top_shard.texture = texture
	top_shard.position = (position - size/2) * 4.0/3.0
	top_shard.dir = Vector2(0, -1).rotated(-cut_angle / 180.0 * PI)
	get_parent().add_child(top_shard)
	
	var bot_shard = load("res://scenes and scripts/monster_polygon.tscn").instance()
	bot_shard.polygon = bot_points
	bot_shard.texture = texture
	bot_shard.position = (position - size/2) * 4.0/3.0
	print(position, '   ', bot_shard.position)
	bot_shard.dir = Vector2(0, 1).rotated(-cut_angle / 180.0 * PI)
	get_parent().add_child(bot_shard)
	

func set_position_to(desired_position: Vector2, modifier: int):
	position = (position * modifier + desired_position) / (modifier + 1)
	
	if (position - desired_position).length() < 5:
		position = desired_position
		return true

func set_scale_to(desired_scale: Vector2, modifier: int):
	scale = (scale * modifier + desired_scale) / (modifier + 1)
	
	if (scale - desired_scale).length() < .1:
		scale = desired_scale
		return true

func set_rotation_to(desired_rotation: float, modifier: int):
	rotation_degrees = (rotation_degrees * modifier + desired_rotation) / (modifier + 1)
	
	if (rotation_degrees - desired_rotation) < 2.5:
		rotation_degrees = desired_rotation
		return true

func set_modulate_to(desired_color: Color, modifier: int):
	modulate = (modulate * modifier + desired_color) / (modifier + 1)
	
	var total = 0
	
	for x in range(4):
		total += modulate[x]
		total -= desired_color[x]
	
	if abs(total) < .05:
		modulate = desired_color
		return true
