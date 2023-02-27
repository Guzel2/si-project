extends AnimatedSprite

var should_move = false

var phase = -1
var timer = 0

var list_of_animations = ['apple', 'bus', 'cheese', 'chopsticks', 'cookie', 'dog', 'fork', 'japan', 'juice', 'milk', 'ramen', 'soccer', 'spoon', 'stamp', 'taxi', 'umbrella', 'one', 'two', 'three', 'four']

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
		if set_position_to(Vector2(450, 340), 8):
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
			if timer >= .35:
				phase = 3
				should_move = false
		3: #fade away
			var should_die = true
			
			if !set_modulate_to(Color(1, 1, 1, 0), 5):
				should_die = false
			if !set_scale_to(Vector2(1.25, .75), 20):
				should_die = false
			if !set_position_to(Vector2(430, 360), 10):
				should_die = false
			
			if should_die:
				phase = 4
			
		4: #die
			queue_free()

func set_position_to(desired_position: Vector2, modifier: int):
	position = (position * modifier + desired_position) / (modifier + 1)
	
	if (position - desired_position).length() < 5:
		return true

func set_scale_to(desired_scale: Vector2, modifier: int):
	scale = (scale * modifier + desired_scale) / (modifier + 1)
	
	if (scale - desired_scale).length() < .1:
		return true

func set_rotation_to(desired_rotation: float, modifier: int):
	rotation_degrees = (rotation_degrees * modifier + desired_rotation) / (modifier + 1)
	
	if (rotation_degrees - desired_rotation) < 2.5:
		return true

func set_modulate_to(desired_color: Color, modifier: int):
	modulate = (modulate * modifier + desired_color) / (modifier + 1)
	
	var total = 0
	
	for x in range(4):
		total += modulate[x]
		total -= desired_color[x]
	
	if abs(total) < .05:
		return true
