extends CanvasLayer

signal start_game
signal  hide_player

@onready var score_text: Label = $MarginContainer/Score
@onready var time_text: Label = $MarginContainer/Time
@onready var message_text: Label = $Message
@onready var timer: Timer = $Timer
@onready var start_button: Button = $StartButton

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.timeout.connect(func():
		message_text.hide()
	)
	
	start_button.pressed.connect(func():
		start_button.hide()
		message_text.hide()
		start_game.emit()
	)
	
func update_score(value: int):
	score_text.text = str(value)
	
func update_timer(value: int):
	time_text.text = str(value)
	
func show_message(text: String):
	message_text.text = text
	message_text.show()
	timer.start()
	
func show_game_over():
	show_message("Game Over")
	await timer.timeout
	start_button.show()
	message_text.text = "Sly Mr Fox!"
	message_text.show()
	hide_player.emit()
