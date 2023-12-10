extends Node2D

var input_direction : Vector2
# var speed = 500
var speed: float = 0.1
var tile_size : int = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	# pass # Replace with function body.
	position = position.snapped(Vector2.ONE * tile_size)
	position -= Vector2.ONE * (tile_size / 2)
	$RayCast2D.target_position = Vector2.DOWN * tile_size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	

func read_input():
	input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	

# func move_topdown(delta):
	# $Sprite2D.position = $Sprite2D.position + input_direction * speed * delta
	
	
func move_topdown(_delta):
	var moving_direction: Vector2 = Vector2.ZERO
	
	if input_direction.length() > 0:
		var movement = Vector2.DOWN
		if input_direction.y > 0: 
			movement = Vector2.DOWN
			$AnimatedSprite2D.play("kristo_down")
		elif input_direction.y < 0: 
			movement = Vector2.UP
			$AnimatedSprite2D.play("kristo_up")
		elif input_direction.x > 0: 
			movement = Vector2.RIGHT
			$AnimatedSprite2D.play("kristo_right")
		elif input_direction.x < 0: 
			movement = Vector2.LEFT
			$AnimatedSprite2D.play("kristo_left")
			
		$RayCast2D.target_position = movement * tile_size
		$RayCast2D.force_raycast_update() 
		
		if !$RayCast2D.is_colliding():
			moving_direction = movement
		
			var new_position = position + (moving_direction * tile_size)
		
			var tween : Tween = create_tween()
			tween.tween_property(self, "position", new_position, speed).set_trans(Tween.TRANS_LINEAR)
			# tween.tween_callback(func(): moving_direction = Vector2.ZERO)
	else:
		$AnimatedSprite2D.play("kristo_idle")

func _physics_process(delta):
	read_input()
	move_topdown(delta)
