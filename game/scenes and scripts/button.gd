extends TextureButton

onready var label = $label

export var text = 'text'

func _ready():
	label.text = text

func _process(_delta):
	if pressed:
		label.rect_position.y = 15
	else:
		label.rect_position.y = 0

