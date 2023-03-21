extends Node2D

onready var parent = get_parent()

var mode

func _ready():
	mode = parent.mode


func _on_daily_pressed():
	parent.enter('vocab_practice')
	parent.exit(self)
