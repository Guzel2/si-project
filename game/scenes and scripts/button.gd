extends TextureButton

onready var label = $label

export var text = 'text'
export var label_offset = Vector2(0, 0)

func _ready():
	label.rect_position += label_offset
	label.text = text

func _process(_delta):
	if pressed:
		label.rect_position.y = 15
	else:
		label.rect_position.y = 0

