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
	'dragon': ['てつ', 'tetsu', 'tetu'],
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

var completed_questions = []

var active = false

var current_question = null

var mode = 'vocab_japanese'

var due_dates = {}

var due_path = 'user://due_dates_'

func _ready():
	randomize()
	mode = parent.mode
	
	
	var data = read_file(due_path + mode + '.dat')
	if data != null: #
		due_dates = data
		
		for new_question in all_questions:
			if !(new_question in due_dates.keys()):
				due_dates[new_question] = {
					'day': 1,
					'dst': false,
					'hour': 0,
					'minute': 0,
					'month': 0,
					'second': 0,
					'weekday': 0,
					'year': 3000
				}
	
	else: #set-up data
		for new_question in all_questions:
			due_dates[new_question] = {
				'day': 1,
				'dst': false,
				'hour': 0,
				'minute': 0,
				'month': 0,
				'second': 0,
				'weekday': 0,
				'year': 3000
			}
	
	save_file(due_dates, due_path + mode + '.dat')


func start_new_round():
	var current_date = OS.get_datetime()
	
	var dict = {
		'one': 1,
		'two': 2
	}
	
	dict['three'] = 3
	
	print(dict)
	
	print('four' in dict.keys())
	
	var time_intervals = ['year', 'month', 'day', 'hour']
	
	for new_question in due_dates.keys():
		for interval in time_intervals:
			if due_dates[new_question][interval] < current_date[interval]:
				due_questions.append(new_question)
				break
			elif due_dates[new_question][interval] > current_date[interval]:
				break
	
	print(due_questions)
	
	if due_questions.size() == 0:
		due_questions = ['zero']
	
	lineedit.placeholder_text = 'translate to English'
	active = true
	due_questions.shuffle()
	completed_questions.clear()
	
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


func next_question():
	if completed_questions.size() >= due_questions.size():
		end_round()
	else:
		completed_questions.append(current_question)
		current_question = due_questions.pop_front()
		due_questions.append(current_question)
		
		monster.set_question(current_question, mode)
		if character.phase == -1:
			character.phase = 0
		else:
			character.phase = 1 #start attack


func _on_lineedit_focus_entered():
	start_new_round()


func _on_lineedit_text_changed(new_text):
	new_text = new_text.to_lower()
	
	match mode:
		'vocab_english':
			if new_text in answers[current_question]:
				lineedit.clear()
				next_question()
		'vocab_japanese':
			if new_text == current_question:
				lineedit.clear()
				next_question()
	
	


func _on_lineedit_focus_exited():
	lineedit.placeholder_text = 'click to start'
