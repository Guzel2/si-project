extends Node2D

onready var parent = get_parent()

onready var lineedit = find_node('lineedit')
onready var reset_lineedit = find_node('reset_lineedit')
onready var camera = find_node('camera')
onready var character = find_node('character')
onready var monster = find_node('monster')
onready var highscore_label = find_node('highscore_label')
onready var new_word = find_node('new_word')

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
	'beer': ['ビール', 'bru'],
	'flower': ['はな', 'hana'],
	'mushroom': ['きのこ', 'kinoko'],
	'notebook': ['ノート', 'nooto'],
	'sushi': ['すし', 'sushi'],
	'airconditioner': ['エアコン', 'eakon'],
	'dango': ['だんご', 'dango'],
	'golf': ['ゴルフ', 'gorufu'],
	'pen': ['ペン', 'pen'],
	'plane': ['ひこうき', 'hikouki'],
	'peach': ['もも', 'momo'],
	'samurai': ['さむらい', 'samurai'],
	'ship': ['ふね', 'fune'],
	'blowfish': ['ふぐ', 'fugu'],
	'sumo': ['すもう', 'sumou'],
	'telephone': ['でんわ', 'denwa'],
	'baseball': ['やきゅう', 'yakyuu'],
	'bowling': ['ボーリング', 'booringu'],
	'bread': ['パン', 'pan'],
	'guitar': ['ギター', 'gitaa'],
	'car': ['くるま', 'kuruma'],
	'mobilephone': ['けいたい', 'keitai'],
	'tennis': ['テニス', 'tenisu'],
	'tie': ['ネクタイ', 'nekutai'],
	'tempura': ['てんぷら', 'tenpura'],
	'yakitori': ['やきとり', 'yakitori'],
	'clock': ['とけい', 'tokei'],
	'house': ['うち', 'uchi'],
	'train': ['でんしゃ', 'densha'],
	'yen': ['えん', 'en']
}

var all_questions = [
	'apple', 'bus', 'cheese', 'chopsticks', 'cookie', 
	'dog', 'fork', 'japan', 'juice', 'milk', 'ramen', 
	'soccer', 'spoon', 'stamp', 'taxi', 'umbrella', 
	'one', 'two', 'three', 'four', 'five', 'six', 
	'seven', 'eight', 'nine', 'ten', 'zero', 'black', 
	'white', 'yellow', 'brown', 'blue', 'green', 'red', 
	'orange', 'pink', 'book', 'dragon', 'television', 
	'knife', 'beer', 'flower', 'mushroom', 'notebook', 
	'sushi', 'airconditioner', 'dango', 'golf', 'pen', 
	'plane', 'peach', 'samurai', 'ship', 'blowfish', 
	'sumo', 'telephone', 'baseball', 'bowling', 'bread', 
	'guitar', 'car', 'mobilephone', 'tennis', 'tie', 
	'tempura', 'yakitori', 'clock', 'house', 'train', 'yen'
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
		for x in range(10):
			due_dates[all_questions[x]] = current_date
			due_dates[all_questions[x]]['interval'] = 0
		
		save_file(due_dates, due_path + mode + '.dat')


func start_new_round():
	streak = 0
	
	var current_date = OS.get_datetime()
	
	var time_intervals = ['year', 'month', 'day', 'hour', 'minute', 'second']
	
	due_questions.clear()
	
	for new_question in due_dates.keys():
		for interval in time_intervals:
			if due_dates[new_question][interval] < current_date[interval]:
				due_questions.append(new_question)
				break
			elif due_dates[new_question][interval] > current_date[interval]:
				break
	
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
		
		var interval = due_dates[current_question]['interval']
		var added_time = 3 * pow(interval, 4)
		var due_time = OS.get_datetime()
		
		due_time = add_time(due_time, added_time)
		
		due_dates[current_question] = due_time
		due_dates[current_question]['interval'] = interval + 1
		
		save_file(due_dates, due_path + mode + '.dat')
		
		streak += 1
		
		if streak == 5: #add new word
			if due_dates.keys().size() <= all_questions.size():
				streak = 0
				new_question()
			else:
				next_question()
		else:
			next_question()


func add_time(time: Dictionary, added_time: int):
	var time_intervals = ['seconds', 'minute', 'hour', 'day', 'month', 'year']
	var time_limits = [1, 60, 1440, 1440 * month_days[time['month']], 525600, 100000000000000000]
	
	while added_time > 0:
		time_limits[3] = 1440 * month_days[time['month']]
		
		for limit in range(1, 5):
			if added_time < time_limits[limit]:
				var modified_time = floor(added_time / time_limits[limit - 1])
				
				time[time_intervals[limit]] += modified_time
				added_time -= modified_time * time_limits[limit - 1]
				time = adjust_time(time)
				
				break
	
	return time


func adjust_time(time: Dictionary):
	var time_intervals = ['minute', 'hour', 'day', 'month', 'year']
	var time_limits = [60, 1440, 1440 * month_days[time['month']], 525600]
	
	for interval in range(time_intervals.size() - 1):
		if time[time_intervals[interval]] >= time_limits[interval]:
			time[time_intervals[interval]] -= time_limits[interval]
			time[time_intervals[interval + 1]] += 1
			
			time_limits[2] = 1440 * month_days[time['month']]
	
	return time


func new_question():
	new_word.visible = true
	
	lineedit.clear()
	current_question = all_questions[due_dates.keys().size()]
	due_dates[current_question] = OS.get_datetime()
	due_dates[current_question]['interval'] = 0
	
	monster.set_question(current_question, mode)


func next_question():
	new_word.visible = false
	
	lineedit.clear()
	current_question = due_questions.pop_front()
	
	monster.set_question(current_question, mode)


func _on_lineedit_focus_entered():
	if !just_showed_answer:
		start_new_round()
	else:
		due_dates[current_question] = OS.get_datetime()
		due_dates[current_question]['interval'] = 0
		
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
