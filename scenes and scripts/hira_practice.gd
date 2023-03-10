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
	'a': ['a', 'あ'],
	'i': ['i', 'い'],
	'u': ['u', 'う'],
	'e': ['e', 'え'],
	'o': ['o', 'お'],
	
	'ka': ['ka', 'か'],
	'ki': ['ki', 'き'],
	'ku': ['ku', 'く'],
	'ke': ['ke', 'け'],
	'ko': ['ko', 'こ'],
	
	'sa': ['sa', 'さ'],
	'shi': ['si', 'shi', 'し'],
	'su': ['su', 'す'],
	'se': ['se', 'せ'],
	'so': ['so', 'そ'],
	
	'ta': ['ta', 'た'],
	'chi': ['ti', 'chi', 'ち'],
	'tsu': ['tu', 'tsu', 'つ'],
	'te': ['te', 'て'],
	'to': ['to', 'と'],
	
	'na': ['na', 'な'],
	'ni': ['ni', 'に'],
	'nu': ['nu', 'ぬ'],
	'ne': ['ne', 'ね'],
	'no': ['no', 'の'],
	
	'ha': ['ha', 'は'],
	'hi': ['hi', 'ひ'],
	'fu': ['hu', 'fu', 'ふ'],
	'he': ['he', 'へ'],
	'ho': ['ho', 'ほ'],
	
	'ma': ['ma', 'ま'],
	'mi': ['mi', 'み'],
	'mu': ['mu', 'む'],
	'me': ['me', 'め'],
	'mo': ['mo', 'も'],
	
	'ya': ['ya', 'や'],
	'yu': ['yu', 'ゆ'],
	'yo': ['yo', 'よ'],
	
	'ra': ['ra', 'ら'],
	'ri': ['ri', 'り'],
	'ru': ['ru', 'る'],
	're': ['re', 'れ'],
	'ro': ['ro', 'ろ'],
	
	'wa': ['wa', 'わ'],
	'wo': ['wo', 'o', 'を'],
}

var all_questions = [
	'a', 'i', 'u', 'e', 'o',
	'ka', 'ki', 'ku', 'ke', 'ko',
	'sa', 'shi', 'su', 'se', 'so',
	'ta', 'chi', 'tsu', 'te', 'to',
	'na', 'ni', 'nu', 'ne', 'no',
	'ha', 'hi', 'fu', 'he', 'ho',
	'ma', 'mi', 'mu', 'me', 'mo',
	'ya', 'yu', 'yo',
	'ra', 'ri', 'ru', 're', 'ro',
	'wa', 'wo'
	]

var due_questions = []

var time = 0
var active = false

var current_question = 'a'

var highscore = 100000
var highscore_path = "user://hira_highscore.dat"

var just_showed_answer = false

func _ready():
	randomize()
	
	if read_file(highscore_path) != null:
		highscore = read_file(highscore_path)


func start_new_round():
	lineedit.placeholder_text = 'write as romaji'
	active = true
	due_questions = all_questions.duplicate()
	due_questions.shuffle()
	time = 0
	
	next_question()


func end_round():
	if time < highscore:
		highscore = time
		save_file(highscore, highscore_path)
	highscore_label.text = 'Best time: ' + String(float(round(highscore*10))/10) + 's'
	
	active = false
	
	reset_lineedit.grab_focus()
	lineedit.clear()
	monster.end_round()


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


func _process(delta):
	if active:
		time += delta



func complete_question():
	if due_questions.empty():
		monster.sprite_dies()
		character.phase = 1 #start attack
		end_round()
	else:
		monster.sprite_dies()
		character.phase = 1 #start attack
		
		next_question()


func next_question():
	lineedit.clear()
	current_question = due_questions.pop_front()
	monster.set_question(current_question, 'hira')


func _on_lineedit_focus_entered():
	if !just_showed_answer:
		start_new_round()
	else: #monster flews
		lineedit.placeholder_text = 'write as romaji'
		monster.sprite_flews()
		due_questions.append(current_question)
		due_questions.shuffle()
		next_question()
		just_showed_answer = false


func _on_lineedit_text_changed(new_text):
	new_text = new_text.to_lower()
	
	if new_text in answers[current_question]:
		complete_question()


func _on_lineedit_focus_exited():
	lineedit.placeholder_text = 'click to start'


func _on_show_answer_pressed():
	lineedit.text = current_question + ' (click to continue)'
	just_showed_answer = true
