extends Label

var high_score = 0
var score = 0
var game_name = ""

func _ready():
	bind_events()
	
func bind_events() -> void:
	EventBus.sigAddScore.connect(_on_increment_score)
	EventBus.sigNewGame.connect(_on_new_game)

func _on_new_game(mode_name: String) ->void:
	game_name = mode_name
	high_score = GameInfo.get_value(game_name, "high_score", 0)

func _on_increment_score(points :int) ->void:
	score = score + points
	text = "Score " + str(score)
	if score > high_score:
		high_score = score
		EventBus.sigNewHighScore.emit(high_score)
