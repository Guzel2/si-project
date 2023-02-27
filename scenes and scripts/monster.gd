extends Node2D

onready var parent = get_parent()
onready var question = find_node('question')
onready var sprite = null

var romaji_to_hiragana = {
	'': '',
	
	'a': 'あ',
	'i': 'い',
	'u': 'う',
	'e': 'え',
	'o': 'お',
	
	'ka': 'か',
	'ki': 'き',
	'ku': 'く',
	'ke': 'け',
	'ko': 'こ',
	
	'sa': 'さ',
	'shi': 'し',
	'su': 'す',
	'se': 'せ',
	'so': 'そ',
	
	'ta': 'た',
	'chi': 'ち',
	'tsu': 'つ',
	'te': 'て',
	'to': 'と',
	
	'na': 'な',
	'ni': 'に',
	'nu': 'ぬ',
	'ne': 'ね',
	'no': 'の',
	
	'ha': 'は',
	'hi': 'ひ',
	'fu': 'ふ',
	'he': 'へ',
	'ho': 'ほ',
	
	'ma': 'ま',
	'mi': 'み',
	'mu': 'む',
	'me': 'め',
	'mo': 'も',
	
	'ya': 'や',
	'yu': 'ゆ',
	'yo': 'よ',
	
	'ra': 'ら',
	'ri': 'り',
	'ru': 'る',
	're': 'れ',
	'ro': 'ろ',
	
	'wa': 'わ',
	'wo': 'を',
}

var romaji_to_katakana = {
	'': '',
	
	'a': 'ア',
	'i': 'イ',
	'u': 'ウ',
	'e': 'エ',
	'o': 'オ',
	
	'ka': 'カ',
	'ki': 'キ',
	'ku': 'ク',
	'ke': 'ケ',
	'ko': 'コ',
	
	'sa': 'サ',
	'shi': 'シ',
	'su': 'ス',
	'se': 'セ',
	'so': 'ソ',
	
	'ta': 'タ',
	'chi': 'チ',
	'tsu': 'ツ',
	'te': 'テ',
	'to': 'ト',
	
	'na': 'ナ',
	'ni': '二',
	'nu': 'ヌ',
	'ne': 'ネ',
	'no': 'ノ',
	
	'ha': 'ハ',
	'hi': 'ヒ',
	'fu': 'フ',
	'he': 'ヘ',
	'ho': 'ホ',
	
	'ma': 'マ',
	'mi': 'ミ',
	'mu': 'ム',
	'me': 'メ',
	'mo': 'モ',
	
	'ya': 'ヤ',
	'yu': 'ユ',
	'yo': 'ヨ',
	
	'ra': 'ラ',
	'ri': 'リ',
	'ru': 'ル',
	're': 'レ',
	'ro': 'ロ',
	
	'wa': 'ワ',
	'wo': 'ヲ',
}

func set_question(new_question, mode):
	if sprite != null:
		sprite.phase = 1
		
		add_new_sprite()
	else:
		add_new_sprite()
		sprite.should_move = true
		sprite.phase = 0
	
	match mode:
		'hira':
			question.text = romaji_to_hiragana[new_question]
		'kata':
			question.text = romaji_to_katakana[new_question]
		'vocab_english':
			question.text = new_question
			sprite.animation = new_question
		'vocab_japanese':
			question.text = parent.answers[new_question][0]
			sprite.animation = new_question

func add_new_sprite():
	var new_sprite = load("res://scenes and scripts/monster_sprite.tscn").instance()
	sprite = new_sprite
	add_child(sprite)
