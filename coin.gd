extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var screen_size: Vector2 = Vector2.ZERO
var offset: float = 0

func _ready():
	$Timer.start(randf_range(3,8))
	
	area_entered.connect(func(area):
		if area.is_in_group("obstacles") and not area.is_in_group("dynamic"):
			position = Vector2(randi_range(offset, screen_size.x), randi_range(offset, screen_size.y))
		)
		
func pickup():
	$CollisionShape2D.set_deferred("disabled", true)
	
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "scale", scale * 3, 0.3)
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	await tween.finished
	
	queue_free()


func _on_timer_timeout():
	animated_sprite.frame = 0
	animated_sprite.play()
	

