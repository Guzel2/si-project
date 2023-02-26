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
	'a': ['a', 'あ', 'ア'],
	'i': ['i', 'い', 'イ'],
	'u': ['u', 'う', 'ウ'],
	'e': ['e', 'え', 'エ'],
	'o': ['o', 'お', 'オ'],
	
	'ka': ['ka', 'か', 'カ'],
	'ki': ['ki', 'き', 'キ'],
	'ku': ['ku', 'く', 'ク'],
	'ke': ['ke', 'け', 'ケ'],
	'ko': ['ko', 'こ', 'コ'],
	
	'sa': ['sa', 'さ', 'サ'],
	'shi': ['si', 'shi', 'し', 'シ'],
	'su': ['su', 'す', 'ス'],
	'se': ['se', 'せ', 'セ'],
	'so': ['so', 'そ', 'ソ'],
	
	'ta': ['ta', 'た', 'タ'],
	'chi': ['ti', 'chi', 'ち', 'チ'],
	'tsu': ['tu', 'tsu', 'つ', 'ツ'],
	'te': ['te', 'て', 'テ'],
	'to': ['to', 'と', 'ト'],
	
	'na': ['na', 'な', 'ナ'],
	'ni': ['ni', 'に', '二'],
	'nu': ['nu', 'ぬ', 'ヌ'],
	'ne': ['ne', 'ね', 'ネ'],
	'no': ['no', 'の', 'ノ'],
	
	'ha': ['ha', 'は', 'ハ'],
	'hi': ['hi', 'ひ', 'ヒ'],
	'fu': ['hu', 'fu', 'ふ', 'フ'],
	'he': ['he', 'へ', 'ヘ'],
	'ho': ['ho', 'ほ', 'ホ'],
	
	'ma': ['ma', 'ま', 'マ'],
	'mi': ['mi', 'み', 'ミ'],
	'mu': ['mu', 'む', 'ム'],
	'me': ['me', 'め', 'メ'],
	'mo': ['mo', 'も', 'モ'],
	
	'ya': ['ya', 'や', 'ヤ'],
	'yu': ['yu', 'ゆ', 'ユ'],
	'yo': ['yo', 'よ', 'ヨ'],
	
	'ra': ['ra', 'ら', 'ラ'],
	'ri': ['ri', 'り', 'リ'],
	'ru': ['ru', 'る', 'ル'],
	're': ['re', 'れ', 'レ'],
	'ro': ['ro', 'ろ', 'ロ'],
	
	'wa': ['wa', 'わ', 'ワ'],
	'wo': ['wo', 'o', 'を', 'ヲ'],
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

var completed_questions = []

var time = 0
var active = false

var current_question = null

var highscore = 100000
var highscore_path = "user://kata_highscore.dat"


func _ready():
	randomize()
	
	if read_file(highscore_path) != null:
		highscore = read_file(highscore_path)


func start_new_round():
	lineedit.placeholder_text = 'write as romaji'
	active = true
	all_questions.shuffle()
	completed_questions.clear()
	time = 0
	
	next_question()


func end_round():
	if time < highscore:
		highscore = time
		save_file(highscore, highscore_path)
	highscore_label.text = 'Best time: ' + String(float(round(highscore*10))/10) + 's'
	
	active = false
	
	reset_lineedit.grab_focus()
	monster.set_question('', false)


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


func next_question():
	if completed_questions.size() >= all_questions.size():
		end_round()
	else:
		completed_questions.append(current_question)
		current_question = all_questions.pop_front()
		all_questions.append(current_question)
		
		monster.set_question(current_question, false)
		if character.phase == -1:
			character.phase = 0
		else:
			character.phase = 1 #start attack


func _on_lineedit_focus_entered():
	start_new_round()


func _on_lineedit_text_changed(new_text):
	new_text = new_text.to_lower()
	
	if new_text in answers[current_question]:
		lineedit.clear()
		next_question()


func _on_lineedit_focus_exited():
	lineedit.placeholder_text = 'click to start'
