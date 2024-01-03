extends Area2D

var screen_size: Vector2 = Vector2.ZERO
var offset: float = 0
var player: Area2D = null
var flipped: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(func(area):
		if player.position.distance_to(position) < 25: 
			position = Vector2(randi_range(offset, screen_size.x), randi_range(offset, screen_size.y))
		
		if area.is_in_group("player") or (area.is_in_group("obstacles") and not area.is_in_group("dynamic")):
			position = Vector2(randi_range(offset, screen_size.x), randi_range(offset, screen_size.y))
		)
		
	$Timer.start(randf_range(1,3))


func _on_timer_timeout():
	flipped = not flipped
	$Sprite2D.flip_h = flipped 
