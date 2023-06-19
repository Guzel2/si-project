extends Polygon2D

var time_to_die = .7
var timer = 0.0

var dir = Vector2(1, 0)
var speed = 180

func _ready():
	position += Vector2(-5, 5)

func _process(delta):
	timer += delta
	
	modulate[3] = 1 - timer / time_to_die
	
	position += dir * modulate[3] * modulate[3] * delta * speed
	
	if timer >= time_to_die:
		queue_free()
