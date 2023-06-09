extends Node2D

onready var parent = get_parent()

onready var buttons = [$hiragana, $katakana, $vocab_practice, $vocab_practice2]

var y_offset = 440

func _ready():
	enter()

func _process(delta):
	y_offset = 440 + get_viewport_rect().size.y / 30
	
	var height = get_viewport_rect().size.y - y_offset
	
	
	height /= 4
	
	var x = 0
	for button in buttons:
		button.rect_position.y = x * height + y_offset
		x += 1

func enter():
	parent.home_button.visible = false

func exit():
	parent.home_button.visible = true
	queue_free()

func _on_hiragana_pressed():
	parent.enter('hira_practice')
	exit()


func _on_katakana_pressed():
	parent.enter('kata_practice')
	exit()


func _on_vocab_practice_pressed():
	parent.mode = 'vocab_japanese'
	parent.enter('vocab_menu')
	exit()


func _on_vocab_practice2_pressed():
	parent.mode = 'vocab_english'
	parent.enter('vocab_menu')
	exit()
