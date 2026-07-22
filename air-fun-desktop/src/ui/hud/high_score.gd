extends Label

var high_score = 0
var game_name = ""

func _ready():
	bind_events()

func bind_events() -> void:
	EventBus.sigNewHighScore.connect(_on_new_high_score)
	EventBus.sigNewGame.connect(_on_new_game)

func display_high_score() -> void:
	text = "HighScore " + str(floori(high_score))

func _on_new_game(mode_name: String) ->void:
	game_name = mode_name
	high_score = GameInfo.get_value(game_name, "high_score", 0)
	display_high_score()

func _on_new_high_score(score: int) -> void:
	if score <= high_score:
		return
	high_score = score
	GameInfo.save_value(game_name, "high_score", high_score)
	display_high_score()
