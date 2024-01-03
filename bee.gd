extends Area2D

@onready var timer: Timer = $Timer

var screen_size: Vector2 = Vector2.ZERO
var offset: float = 0
var player: Area2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start()
	
	area_entered.connect(func(area):
		if player.position.distance_to(position) < 25: 
			position = Vector2(randi_range(offset, screen_size.x), randi_range(offset, screen_size.y))
		
		if area.is_in_group("player"):
			position = Vector2(randi_range(offset, screen_size.x), randi_range(offset, screen_size.y))
		)
		

func _on_timer_timeout():
	var tween:Tween = create_tween()
	var current_pos: Vector2 = position
	var rand_pos: Vector2 = Vector2(randf_range(offset, screen_size.x), randf_range(offset, screen_size.y))
	$AnimatedSprite2D.flip_h = rand_pos.x > current_pos.x
	
	tween.tween_property(self, "position", rand_pos, randf_range(1.5,4))
	tween.tween_callback( func():
		timer.wait_time = randf_range(0.3, 1.5)
		timer.start()
		)
	
	
