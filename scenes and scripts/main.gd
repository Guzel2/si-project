extends Node2D

var node_paths = {
	'main_menu': "res://scenes and scripts/main_menu.tscn",
	'hira_practice': "res://scenes and scripts/hira_practice.tscn",
	'kata_practice': "res://scenes and scripts/kata_practice.tscn",
}

func enter(node):
	var new_node = load(node_paths[node]).instance()
	add_child(new_node)

func exit(node):
	node.queue_free()