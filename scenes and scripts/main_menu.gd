extends Node2D

onready var parent = get_parent()

func _ready():
	enter()

func enter():
	parent.home_button.visible = false

func exit():
	parent.home_button.visible = true
	queue_free()

func _on_hiragana_pressed():
	parent.enter('hira_menu')
	exit()


func _on_katakana_pressed():
	parent.enter('kata_menu')
	exit()


func _on_vocab_practice_pressed():
	parent.mode = 'vocab_japanese'
	parent.enter('vocab_menu')
	exit()


func _on_vocab_practice2_pressed():
	parent.mode = 'vocab_english'
	parent.enter('vocab_menu')
	exit()
