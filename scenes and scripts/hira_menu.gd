extends Node2D

onready var parent = get_parent()

func _on_hira_learn_pressed():
	pass # Replace with function body.


func _on_hira_practice_pressed():
	parent.enter('hira_practice')
	parent.exit(self)
