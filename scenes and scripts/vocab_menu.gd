extends Node2D

onready var parent = get_parent()

var mode
var due_questions = []

var all_questions = [
	#start stuff (4)
	'japan', 'apple', 'chopsticks', 'toilet',
	#nature (10)
	'flower', 'mushroom', 'cat', 'dog', 'spider', 'centipede', 'mantis', 'dragon', 'blowfish', 'temple_gate',
	#city (20)
	'ship', 'house', 'bicycle', 'camera', 'dress', 't-shirt', 'suit', 'tie', 'shoes', 'yen', 'stamp',
	'mobilephone', 'train', 'car', 'taxi', 'bus', 'plane', 'motorcycle', 'trousers', 'umbrella',
	#food (16)
	'beer', 'sushi', 'peach', 'cookie', 'juice', 'cheese', 'tea', 'milk', 'yakitori',
	'tempura', 'ramen', 'mochi', 'bread', 'dango', 'onigiri', 'coffee',
	#numbers (11)
	'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten', 'zero',
	#household (19)
	'knife', 'notebook', 'television', 'spoon', 'fork', 'video_game',
	'computer', 'book', 'chair', 'telephone', 'key', 'manga', 'pen', 'newspaper', 'table',
	'matches', 'radio', 'airconditioner', 'clock',
	#activities (11)
	'soccer', 'basketball', 'tennis', 'baseball', 'golf', 'kendo', 'bowling', 'samurai', 'sumo', 'violin', 'guitar',
	#color (9)
	'red', 'white', 'black', 'green', 'blue', 'yellow', 'pink', 'brown', 'orange'
	]

var nature = ['japan', 'flower', 'mushroom', 'cat', 'dog', 'spider', 'centipede', 'mantis', 'dragon', 'blowfish', 'temple_gate']
var city = ['ship', 'house', 'bicycle', 'camera', 'dress', 't-shirt', 'suit', 'tie', 'shoes', 'yen', 'stamp',
	'mobilephone', 'train', 'car', 'taxi', 'bus', 'plane', 'motorcycle', 'trousers', 'umbrella',]
var food = ['beer', 'sushi', 'peach', 'cookie', 'juice', 'cheese', 'tea', 'milk', 'yakitori',
	'tempura', 'ramen', 'mochi', 'bread', 'dango', 'onigiri', 'coffee', 'apple']
var numbers = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten', 'zero']
var household = ['knife', 'notebook', 'television', 'spoon', 'fork', 'video_game',
	'computer', 'book', 'chair', 'telephone', 'key', 'manga', 'pen', 'newspaper', 'table',
	'matches', 'radio', 'airconditioner', 'clock', 'chopsticks', 'toilet']
var activities = ['soccer', 'basketball', 'tennis', 'baseball', 'golf', 'kendo', 'bowling', 'samurai', 'sumo', 'violin', 'guitar',]
var color = ['red', 'white', 'black', 'green', 'blue', 'yellow', 'pink', 'brown', 'orange']

var due_dates = {}

var due_path = 'user://due_dates_'

func save_file(content, path):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_var(content)
	file.close()


func read_file(path):
	var file = File.new()
	file.open(path, File.READ)
	var content = file.get_var()
	file.close()
	return(content)

func _ready():
	randomize()
	mode = parent.mode
	
	var data = read_file(due_path + mode + '.dat')
	if data != null:
		due_dates = data
	else:
		var current_date = OS.get_datetime()
		for x in range(10):
			due_dates[all_questions[x]] = current_date
			due_dates[all_questions[x]]['interval'] = 0
		
		save_file(due_dates, due_path + mode + '.dat')
	
	var current_date = OS.get_datetime()
	var time_intervals = ['year', 'month', 'day', 'hour', 'minute', 'second']
	
	due_questions.clear()
	
	for new_question in due_dates.keys():
		for interval in time_intervals:
			if due_dates[new_question][interval] <= current_date[interval]:
				due_questions.append(new_question)
				break
			elif due_dates[new_question][interval] > current_date[interval]:
				break
	
	find_node('daily_label').text = 'Daily Practice\n Due Words: ' + String(due_questions.size())
	
	if due_dates.size() < 10:
		find_node('nature_label').text += '(locked)'
	if due_dates.size() < 20:
		find_node('city_label').text += '(locked)'
	if due_dates.size() < 40:
		find_node('food_label').text += '(locked)'

func _on_daily_pressed():
	if due_questions.size() == 0: #if there are no due questions, what do?
		print('sus')
	else:
		enter_this('vocab_practice')

func generate_pool_with_learned_words(max_interval):
	var pool = []
	for question in due_dates.keys():
		if due_dates[question]['interval'] < max_interval:
			for x in range(max_interval-due_dates[question]['interval']):
				pool.append(question)
	
	pool.shuffle()
	return pool

func _on_nature_pressed():
	if due_dates.size() >= 10:
		due_questions.clear()
		
		var pool = generate_pool_with_learned_words(5)
		for x in range(3):
			due_questions.append(pool.pop_front())
		pool.clear()
		
		
		for question in nature:
			if question in due_dates.keys():
				pool.append(question)
		pool.shuffle()
		for x in range(7):
			var question = pool.pop_front()
			due_questions.append(question)
			pool.append(question)
		
		enter_this('vocab_practice')

func _on_city_pressed():
	if due_dates.size() >= 20:
		due_questions.clear()
		
		var pool = generate_pool_with_learned_words(5)
		for x in range(6):
			due_questions.append(pool.pop_front())
		pool.clear()
		
		
		for question in city:
			if question in due_dates.keys():
				pool.append(question)
		pool.shuffle()
		for x in range(14):
			var question = pool.pop_front()
			due_questions.append(question)
			pool.append(question)
		
		enter_this('vocab_practice')

func _on_food_pressed():
	if due_dates.size() >= 40:
		due_questions.clear()
		
		var pool = generate_pool_with_learned_words(5)
		for x in range(4):
			due_questions.append(pool.pop_front())
		pool.clear()
		
		
		for question in city:
			if question in due_dates.keys():
				pool.append(question)
		pool.shuffle()
		for x in range(11):
			var question = pool.pop_front()
			due_questions.append(question)
			pool.append(question)
		
		enter_this('vocab_practice')

func enter_this(dungeon):
	due_questions.shuffle()
	parent.due_questions = due_questions
	parent.enter(dungeon)
	parent.exit(self)




