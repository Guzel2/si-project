extends Sprite

onready var question = find_node('question')

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

func set_question(new_question):
	question.text = romaji_to_hiragana[new_question]
