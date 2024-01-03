extends Area2D

signal pickup
signal hurt

@onready var animatedSprite2D: AnimatedSprite2D = $AnimatedSprite2D
@export var speed: float = 350
var velocity: Vector2 = Vector2.ZERO
var screen_size: Vector2 = Vector2.ZERO
var offset: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(on_area_entered)

func start():
	set_process(true)
	position = screen_size * 0.5
	animatedSprite2D.animation = "idle"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += velocity * speed * delta
	position.x = clamp(position.x, offset, screen_size.x)
	position.y = clamp(position.y, offset, screen_size.y)
	
	if velocity.length() > 0:
		animatedSprite2D.animation = "run"
	else:
		animatedSprite2D.animation = "idle"
		
	if velocity.x != 0:
		animatedSprite2D.flip_h = velocity.x < 0

func die():
	animatedSprite2D.animation = "hurt"
	set_process(false)
	
func on_area_entered(area: Area2D):
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coin")
		
	if area.is_in_group("powerups"):
		area.pickup()
		pickup.emit("powerup")
		
	if area.is_in_group("obstacles"):
		hurt.emit()
		die()
