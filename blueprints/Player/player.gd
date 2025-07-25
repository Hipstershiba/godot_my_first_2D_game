extends Area2D
signal hit

# How fast the player will move(pixels/sec).
@export var speed = 400
# Size of the game window.
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Player movement vector.
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# If velocity is negative (move_left) flip_h will be true 
		# and the sprite will be flipped.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(_body: Node2D) -> void:
	# Player disappears after being hit.
	hide()
	hit.emit()
	# Must be deferres as we can't change physics properties
	$CollisionShape2D.set_deferred("disabled", true)
	
	
func start(pos):
	position = pos
	$AnimatedSprite2D.flip_v = false
	$AnimatedSprite2D.flip_h = false
	show()
	$CollisionShape2D.disabled = false
