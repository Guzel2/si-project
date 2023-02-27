extends Node2D

onready var parent = get_parent()

func _on_hira_practice_pressed():
	parent.enter('hira_practice')
	parent.exit(self)


func _on_kata_practice_pressed():
	parent.enter('kata_practice')
	parent.exit(self)


func _on_vocab_practice_pressed():
	parent.enter('vocab_practice')
	parent.exit(self)
