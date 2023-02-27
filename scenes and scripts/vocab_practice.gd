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
	'apple': ['りんご', 'ringo'], 
	'bus': ['バス', 'basu'], 
	'cheese': ['チーズ', 'chiizu'], 
	'chopsticks': ['おはし', 'ohashi', 'はし', 'hashi'], 
	'cookie': ['クッキ', 'kukkii'], 
	'dog': ['いぬ', 'inu'], 
	'fork': ['フォオク', 'fooku'], 
	'japan': ['にほん', 'nihon'], 
	'juice': ['ジュウス', 'juusu'], 
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
	'zero'
	]

var due_questions = []

var completed_questions = []

var active = false

var current_question = null

var mode = 'vocab_japanese'

func _ready():
	randomize()


func start_new_round():
	print('sus')
	lineedit.placeholder_text = 'translate to English'
	active = true
	due_questions = all_questions.duplicate()
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
