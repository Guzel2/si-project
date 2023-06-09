extends Node2D

onready var home_button = find_node('home_button')

var node_paths = {
	'main_menu': "res://scenes and scripts/main_menu.tscn",
	'hira_menu': "res://scenes and scripts/hira_menu.tscn",
	'hira_practice': "res://scenes and scripts/hira_practice.tscn",
	'kata_menu': "res://scenes and scripts/kata_menu.tscn",
	'kata_practice': "res://scenes and scripts/kata_practice.tscn",
	'vocab_menu': "res://scenes and scripts/vocab_menu.tscn",
	'vocab_practice': "res://scenes and scripts/vocab_practice.tscn",
}

var mode = 'vocab_english'
var due_questions

var current_node = null

func _ready():
	enter('main_menu')


func enter(node):
	print(mode)
	var new_node = load(node_paths[node]).instance()
	add_child(new_node)
	current_node = new_node


func exit(node):
	node.queue_free()

func return_to_previous():
	pass

func return_to_home():
	exit(current_node)
	enter('main_menu')

func _on_home_button_released():
	return_to_home()
