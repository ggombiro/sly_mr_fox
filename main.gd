extends Node2D

@export var coin_scene: PackedScene
@export var powerup_scene: PackedScene
@export var cactus_scene: PackedScene
@export var bee_scene: PackedScene
@export var play_time: int = 30
@export var offset: float = 0.5

@onready var player = $Player
@onready var game_timer : Timer = $GameTimer
@onready var hud = $HUD
@onready var powerup_timer = $PowerupTimer

var level: int = 1
var score: int = 0
var time_left: int = 0
var screen_size: Vector2 = Vector2.ZERO
var playing: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport().get_visible_rect().size - Vector2(offset, offset)
	player.screen_size = screen_size 
	player.offset = offset
	
	player.hurt.connect(func():
		game_over()
		)
		
	player.pickup.connect(func (type: String):
		match type:
			"coin":
				score += 1
				hud.update_score(score)
				$CoinSound.play()
			"powerup":
				time_left += 5
				hud.update_timer(time_left)
				$PowerupSound.play()
		)
		
	player.hide()
	
	hud.start_game.connect(func ():
		new_game()
		)
		
	hud.hide_player.connect(func ():
		player.hide()
		)
		
	game_timer.timeout.connect(on_game_timer_timeout)
	
	powerup_timer.timeout.connect(on_powerup_timer_timeout)
	
func new_game():
	playing = true
	level = 1
	score = 0
	time_left = play_time
	player.start()
	player.show()
	game_timer.start()
	spawn_cacti()
	spawn_coins()
	spawn_bees()
	hud.update_score(score)
	hud.update_timer(time_left)

func spawn_coins():
	for i in level + 1:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screen_size = screen_size
		c.offset = offset
		
		var rand_pos: Vector2 = player.position
		
		while rand_pos == player.position:
			rand_pos = Vector2(randi_range(offset, screen_size.x), randi_range(offset, screen_size.y))
			
		c.position = Vector2(randi_range(offset, screen_size.x), randi_range(offset, screen_size.y))
	
	$LevelSound.play()
	
func spawn_cacti():
	get_tree().call_group("obstacles", "queue_free")
		
	var number_to_spawn: int = ceili(level * 0.5)
	for i in number_to_spawn:
		var cactus = cactus_scene.instantiate()
		add_child(cactus)
		cactus.screen_size = screen_size
		cactus.offset = offset
		cactus.player = player
		var rand_pos: Vector2 = player.position
		
		while rand_pos == player.position:
			rand_pos = Vector2(randi_range(offset, screen_size.x), randi_range(offset, screen_size.y))
			
		cactus.position = rand_pos

func spawn_bees():
	#for i in level + 1:
		var bee = bee_scene.instantiate()
		add_child(bee)
		bee.screen_size = screen_size
		bee.offset = offset
		bee.player = player
		
		var rand_pos: Vector2 = player.position
		
		while rand_pos == player.position:
			rand_pos = Vector2(randi_range(offset, screen_size.x), randi_range(offset, screen_size.y))
			
		bee.position = Vector2(randi_range(offset, screen_size.x), randi_range(offset, screen_size.y))		
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		time_left += 5
		#player.start()
		spawn_cacti()
		spawn_coins()
		spawn_bees()
		powerup_timer.start()

func on_game_timer_timeout():
	time_left -= 1
	hud.update_timer(time_left)
	
	if time_left <= 0:
		game_over()
		
func on_powerup_timer_timeout():
	var powerup = powerup_scene.instantiate()
	add_child(powerup)
	powerup.screen_size = screen_size
	powerup.offset = offset
	powerup.position = Vector2(randi_range(offset, screen_size.x), randi_range(offset, screen_size.y))

func game_over():
	$EndSound.play()
	playing = false
	game_timer.stop()
	get_tree().call_group("coins", "queue_free")	
	get_tree().call_group("obstacles", "queue_free")
	hud.show_game_over()
	player.die()
