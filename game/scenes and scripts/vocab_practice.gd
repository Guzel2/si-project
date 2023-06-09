extends Node2D

onready var parent = get_parent()

onready var lineedit = find_node('lineedit')
onready var reset_lineedit = find_node('reset_lineedit')
onready var camera = find_node('camera')
onready var character = find_node('character')
onready var monster = find_node('monster')
onready var highscore_label = find_node('highscore_label')
onready var new_word = find_node('new_word')
onready var show_answer = $show_answer

var started = false

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
	'yen': ['えん', 'en'],
	'shoe': ['くつ', 'kutsu', 'kutu'], 
	't-shirt': ['ティーシャツ', 'tiishatsu'], 
	'tabel': ['テーブル', 'teeburu'],
	'coffee': ['コーヒー', 'koohii'], 
	'computer': ['コンピューター', 'konpyuuta'],
	'manga': ['まんが', 'manga'],
	'tea': ['おちゃ', 'ocha'],
	'trousers': ['ズボン', 'zubon'],
	'newspaper': ['しんぶん', 'shinbun'],
	'key': ['かがみ', 'kagami'],
	'basketball': ['バスケットボール', 'basukettobooru'], 
	'kendo': ['けんどう', 'kendou'], 
	'onigiri': ['おにぎり', 'onigiri'], 
	'radio': ['ラジオ', 'rajio'], 
	'spider': ['くも', 'kumo'],
	'camera': ['カメラ', 'kamera'], 
	'chair': ['いす', 'isu'], 
	'dress': ['ワンピース', 'wanpiizu'], 
	'matches': ['マッチ', 'macchi'], 
	'suit': ['せびろ', 'sebiro'],
	'bicycle': ['じてんしゃ', 'jitensha'], 
	'cat': ['ねこ', 'neko'], 
	'centipede': ['ムカデ', 'mukade'], 
	'mantis': ['カマキリ', 'kamakiri'], 
	'mochi': ['もち', 'mochi'],
	'motorcycle': ['バイク', 'paiku'], 
	'temple_gate': ['とりい', 'torii'], 
	'toilet': ['トイレ', 'toire'],
	'video_game': ['ゲーム', 'geemu'], 
	'violin': ['バイオリン', 'baiorin']
}

var synonyms = {
	'': [''],
	'apple': ['apple'], 
	'bus': ['bus'], 
	'cheese': ['cheese'], 
	'chopsticks': ['chopsticks'], 
	'cookie': ['cookie', 'biscuit'], 
	'dog': ['dog'], 
	'fork': ['fork'], 
	'japan': ['japan'], 
	'juice': ['juice'], 
	'milk': ['milk'], 
	'ramen': ['ramen'], 
	'soccer': ['soccer', 'football'], 
	'spoon': ['spoon'], 
	'stamp': ['stamp', 'postage stamp'],
	'taxi': ['taxi', 'uber'], 
	'umbrella': ['umbrella', 'parasol', 'sunshade'], 
	'one': ['one'], 
	'two': ['two'], 
	'three': ['three'], 
	'four': ['four'],
	'five': ['five'],
	'six': ['six'],
	'seven': ['seven'],
	'eight': ['eight'],
	'nine': ['nine'],
	'ten': ['ten'],
	'zero': ['zero'],
	'black': ['black'],
	'white': ['white'],
	'yellow': ['yellow'],
	'brown': ['brown'],
	'blue': ['blue', 'dark blue'],
	'green': ['green'],
	'red': ['red'],
	'orange': ['orange'],
	'pink': ['pink', 'rosa', 'rose'],
	'book': ['book'],
	'dragon': ['dragon'],
	'television': ['television', 'tv'],
	'knife': ['knife'],
	'beer': ['beer'],
	'flower': ['flower'],
	'mushroom': ['mushroom'],
	'notebook': ['notebook'],
	'sushi': ['sushi'],
	'airconditioner': ['airconditioner', 'ac'],
	'dango': ['dango'],
	'golf': ['golf'],
	'pen': ['pen', 'ball pen', 'ballpen'],
	'plane': ['plane', 'airplane'],
	'peach': ['peach'],
	'samurai': ['samurai'],
	'ship': ['ship'],
	'blowfish': ['blowfish'],
	'sumo': ['sumo'],
	'telephone': ['telephone', 'landline', 'fixed network', 'fixed line', 'fixed line network'],
	'baseball': ['baseball'],
	'bowling': ['bowling', 'skittle'],
	'bread': ['bread'],
	'guitar': ['guitar'],
	'car': ['car', 'automobile'],
	'mobilephone': ['mobilephone', 'mobile', 'phone'],
	'tennis': ['tennis'],
	'tie': ['tie', 'necktie'],
	'tempura': ['tempura'],
	'yakitori': ['yakitori'],
	'clock': ['clock', 'watch'],
	'house': ['house', 'home'],
	'train': ['train', 'railroad'],
	'yen': ['yen'],
	'shoe': ['shoe', 'footwear'], 
	't-shirt': ['t-shirt', 'shirt'], 
	'tabel': ['table'],
	'coffee': ['cooffee'], 
	'computer': ['computer', 'pc'],
	'manga': ['comic', 'manga'],
	'tea': ['tea'],
	'trousers': ['trouser', 'trousers', 'pants'],
	'newspaper': ['newspaper', 'paper'],
	'key': ['key'],
	'basketball': ['basketball'], 
	'kendo': ['kendo'], 
	'onigiri': ['onigiri'], 
	'radio': ['radio'], 
	'spider': ['spider'],
	'camera': ['camera', 'photo camera'], 
	'chair': ['chair'], 
	'dress': ['dress'], 
	'matches': ['matches', 'matchsticks', 'matchbooks'], 
	'suit': ['suit'],
	'bicycle': ['bicycle', 'bike'], 
	'cat': ['cat'], 
	'centipede': ['centipede', 'millipede'], 
	'mantis': ['mantis', 'praying mantis'], 
	'mochi': ['mochi'],
	'motorcycle': ['motorcycle', 'motor bike', 'bike'], 
	'temple_gate': ['temple gate', 'gate'], 
	'toilet': ['toilet'],
	'video_game': ['video game', 'game'], 
	'violin': ['violin', 'fiddle']
	}

var all_questions = [
	#start stuff
	'japan', 'apple', 'chopsticks', 'toilet',
	#nature
	'flower', 'mushroom', 'cat', 'dog', 'spider', 'centipede', 'mantis', 'dragon', 'blowfish', 'temple_gate',
	#city
	'ship', 'house', 'bicycle', 'camera', 'dress', 't-shirt', 'suit', 'tie', 'shoes', 'yen', 'stamp',
	'mobilephone', 'train', 'car', 'taxi', 'bus', 'plane', 'motorcycle', 'trousers', 'umbrella',
	#food
	'beer', 'sushi', 'peach', 'cookie', 'juice', 'cheese', 'tea', 'milk', 'yakitori',
	'tempura', 'ramen', 'mochi', 'bread', 'dango', 'onigiri', 'coffee',
	#numbers
	'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten', 'zero',
	#household
	'knife', 'notebook', 'television', 'spoon', 'fork', 'video_game',
	'computer', 'book', 'chair', 'telephone', 'key', 'manga', 'pen', 'newspaper', 'table',
	'matches', 'radio', 'airconditioner', 'clock',
	#activities
	'soccer', 'basketball', 'tennis', 'baseball', 'golf', 'kendo', 'bowling', 'samurai', 'sumo', 'violin', 'guitar',
	#color
	'red', 'white', 'black', 'green', 'blue', 'yellow', 'pink', 'brown', 'orange'
	]

var due_questions = []

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
	due_questions = parent.due_questions
	
	
	due_dates = read_file(due_path + mode + '.dat')


func start_new_round():
	started = true
	lineedit.placeholder_text = 'Translate'
	
	next_question()


func end_round():
	started = false
	parent.return_to_home()
	
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
		
		if streak == 4: #add new word
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
		
		lineedit.placeholder_text = 'Translate'
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
			if new_text in synonyms[current_question]:
				lineedit.clear()
				complete_question()


func _on_lineedit_focus_exited():
	lineedit.placeholder_text = 'Click to start'


func _on_show_answer_pressed():
	if started:
		streak = 0
		
		match mode:
			'vocab_english':
				lineedit.text = answers[current_question][0]
			'vocab_japanese':
				lineedit.text = current_question.capitalize()
		
		just_showed_answer = true


func _on_show_answer_button_down():
	if started:
		lineedit.placeholder_text = 'Translate'