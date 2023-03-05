extends Node2D

onready var parent = get_parent()

onready var lineedit = find_node('lineedit')
onready var reset_lineedit = find_node('reset_lineedit')
onready var camera = find_node('camera')
onready var character = find_node('character')
onready var monster = find_node('monster')
onready var highscore_label = find_node('highscore_label')

var question

var answers = {
	'': [''],
	'apple': ['りんご', 'ringo'], 
	'bus': ['バス', 'basu'], 
	'cheese': ['チーズ', 'chiizu'], 
	'chopsticks': ['おはし', 'ohashi', 'はし', 'hashi'], 
	'cookie': ['クッキー', 'kukkii'], 
	'dog': ['いぬ', 'inu'], 
	'fork': ['フォーク', 'fooku'], 
	'japan': ['にほん', 'nihon'], 
	'juice': ['ジュース', 'juusu'], 
	'milk': ['ぎゅうにゅう', 'gyuunyuu'], 
	'ramen': ['ラーメン', 'raamen'], 
	'soccer': ['サッカー', 'sakkaa'], 
	'spoon': ['スプーン', 'supuun'], 
	'stamp': ['きって', 'kitte'],
	'taxi': ['タクシー', 'takushii'], 
	'umbrella': ['かさ', 'kasa'], 
	'one': ['いち', 'ichi'], 
	'two': ['に', 'ni'], 
	'three': ['さん', 'san'], 
	'four': ['よん', 'yon'],
	'five': ['ご', 'go'],
	'six': ['ろく', 'roku'],
	'seven': ['なな', 'nana'],
	'eight': ['はち', 'hachi'],
	'nine': ['きゅう', 'kyuu'],
	'ten': ['じゅう', 'juu'],
	'zero': ['ゼロ', 'zero'],
	'black': ['くろい', 'くろ', 'kuroi', 'kuro'],
	'white': ['しろい', 'しろ', 'shiroi', 'shiro'],
	'yellow': ['きいろい', 'きいろ', 'kiiroi', 'kiiro'],
	'brown': ['ちゃいろ', 'chairo'],
	'blue': ['こんいろ', 'koniro', ' あおい', 'aoi', 'あお', 'ao'],
	'green': ['みどりいろ', 'みどり', 'midoriiro', 'midori'],
	'red': ['あかい', 'あか', 'akai', 'aka'],
	'orange': ['オレンジいろ', 'orenjiiro'],
	'pink': ['ビンク', 'pinku'],
	'book': ['ほん', 'hon'],
	'dragon': ['たつ', 'tatsu', 'tatu'],
	'television': ['テレビ', 'terebi'],
	'knife': ['ナイフ', 'naifu'],
}

var all_questions = [
	'apple', 
	'bus', 
	'cheese', 
	'chopsticks', 
	'cookie', 
	'dog', 
	'fork', 
	'japan', 
	'juice', 
	'milk', 
	'ramen', 
	'soccer', 
	'spoon', 
	'stamp', 
	'taxi', 
	'umbrella', 
	'one', 
	'two', 
	'three', 
	'four',
	'five',
	'six',
	'seven',
	'eight',
	'nine',
	'ten',
	'zero',
	'black',
	'white',
	'yellow',
	'brown',
	'blue',
	'green',
	'red',
	'orange',
	'pink',
	'book',
	'dragon',
	'television',
	'knife',
	]

var due_questions = []

var active = false

var current_question = 'apple'

var mode = 'vocab_japanese'

var due_dates = {}

var due_path = 'user://due_dates_'

var month_days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

var just_showed_answer = false

var streak = 0

func _ready():
	randomize()
	mode = parent.mode
	
	var data = read_file(due_path + mode + '.dat')
	if data != null: #
		due_dates = data
	else:
		var current_date = OS.get_datetime()
		for x in range(5):
			due_dates[all_questions[x]] = current_date
			due_dates['interval'] = 0
		
		save_file(due_dates, due_path + mode + '.dat')
	
	print(due_dates)


func start_new_round():
	var current_date = OS.get_datetime()
	
	var time_intervals = ['year', 'month', 'day', 'hour', 'minute', 'second']
	
	for new_question in due_dates.keys():
		for interval in time_intervals:
			if due_dates[new_question][interval] < current_date[interval]:
				due_questions.append(new_question)
				break
			elif due_dates[new_question][interval] > current_date[interval]:
				break
	
	print(due_questions)
	
	#due_questions = all_questions.duplicate()
	
	if due_questions.size() == 0: #if there are no due questions, what do?
		due_questions = ['zero']
	
	lineedit.placeholder_text = 'translate'
	active = true
	due_questions.shuffle()
	
	next_question()


func end_round():
	active = false
	
	reset_lineedit.grab_focus()
	monster.set_question('', mode)


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


func complete_question():
	if due_questions.empty():
		monster.sprite_dies()
		character.phase = 1 #start attack
		end_round()
	else:
		monster.sprite_dies()
		character.phase = 1 #start attack
		
		var current_time = OS.get_datetime()
		var interval = due_dates[current_question]['interval']
		var added_time = pow(2, interval)
		var due_time = current_time.duplicate()
		
		while added_time > 0:
			if added_time < 60: #add to minutes
				due_time['minute'] += added_time
				added_time -= added_time
				adjust_time(due_time)
			elif added_time < 1400: #add to hours
				var hours = floor(added_time/60)
				due_time['hour'] += hours
				added_time -= hours * 60
				adjust_time(due_time)
			elif added_time < 1440 * month_days[current_time['month']]: #add to days
				var days = floor(added_time/1440)
				due_time['day'] += days
				added_time -= days * 1440
				adjust_time(due_time)
			elif added_time < 525600: #add to month
				var months = floor(added_time/1440 * month_days[current_time['month']])
				due_time['months'] += months
				added_time -= months * 1440 * month_days[current_time['month']]
			else: #add to year
				var years = floor(added_time/525600)
				due_time['year'] += years
				added_time -= years * 525600
		
		due_dates[current_question] = due_time
		due_dates[current_question]['interval'] = interval
		
		save_file(due_dates, due_path + mode + '.dat')
		
		streak += 1
		
		if streak == 5: #add new word
			streak = 0
			next_question()
		else:
			next_question()

func adjust_time(time: Dictionary):
	var time_intervals = ['minute', 'hour', 'day', 'month', 'year']
	var time_limits = [60, 1440, 1440 * month_days[time['month']], 525600]
	
	for interval in range(time_intervals.size() - 1):
		if time[time_intervals[interval]] >= time_limits[time_intervals[interval]]:
			time[time_intervals[interval]] -= time_limits[time_intervals[interval]]
			time[time_intervals[interval + 1]] += 1
			
			time_limits[2] = 1440 * month_days[time['month']]
	return time

func next_question():
	lineedit.clear()
	current_question = due_questions.pop_front()
	monster.set_question(current_question, mode)


func _on_lineedit_focus_entered():
	if !just_showed_answer:
		start_new_round()
	else:
		lineedit.placeholder_text = 'translate'
		monster.sprite_flews()
		due_questions.append(current_question)
		due_questions.shuffle()
		next_question()
		just_showed_answer = false


func _on_lineedit_text_changed(new_text):
	new_text = new_text.to_lower()
	
	match mode:
		'vocab_english':
			if new_text in answers[current_question]:
				lineedit.clear()
				complete_question()
		'vocab_japanese':
			if new_text == current_question:
				lineedit.clear()
				complete_question()


func _on_lineedit_focus_exited():
	lineedit.placeholder_text = 'click to start'


func _on_show_answer_pressed():
	streak = 0
	
	match mode:
		'vocab_english':
			lineedit.text = answers[current_question][0]
		'vocab_japanese':
			lineedit.text = current_question
	
	just_showed_answer = true
