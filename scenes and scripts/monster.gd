extends Node2D

onready var question = find_node('question')
onready var sprite = find_node('sprite')

var phase = -1
var timer = 0

var desired_x = 450
var modifier = 8

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

func _process(delta):
	match phase:
		0: #do nothing
			pass
		1: #set up wait
			if sprite.modulate[3] != 1:
				sprite.modulate = Color(1, 1, 1, 1)
				sprite.position.x = 920
			
			timer = 0
			phase = 2
		2: #wait  sec
			sprite.position.x = (sprite.position.x * modifier + desired_x) / (modifier + 1)
			
			timer += delta
			if timer >= .35:
				phase = 3
		3: #fade away
			var color = sprite.modulate
			color[3] -= delta * 3.5
			
			sprite.modulate = color
			
			if color[3] <= 0:
				phase = 4
		4: #start walk in
			sprite.modulate = Color(1, 1, 1, 1)
			sprite.position.x = 920
			phase = 5
		5: #walk in
			sprite.position.x = (sprite.position.x * modifier + desired_x) / (modifier + 1)
			
			if sprite.position.x - 450 < 1:
				sprite.position.x = 450
				phase = 0

func set_question(new_question, its_hiragana):
	if its_hiragana:
		question.text = romaji_to_hiragana[new_question]
	else:
		question.text = romaji_to_katakana[new_question]
	
	if phase == -1:
		phase = 4
	else:
		phase = 1
