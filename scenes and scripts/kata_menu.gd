extends Node2D

onready var parent = get_parent()

func _on_kata_learn_pressed():
	pass # Replace with function body.


func _on_kata_practice_pressed():
	parent.enter('kata_practice')
	parent.exit(self)
