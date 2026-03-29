extends CharacterBody2D


@export var walk_speed: float = 150.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

#Funcion que maneja el movimiento general del player.
func _physics_process(delta: float) -> void:
	var direction := get_input_direction()
	
	velocity = direction.normalized() * walk_speed
	move_and_slide()

	update_animations(direction)
	
#Funcion que devuelve la direccion del player fozando entre 4 direcciones.
func get_input_direction() -> Vector2:
	var dir = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		dir.x = 1
	elif Input.is_action_pressed("move_left"):
		dir.x = -1
	elif Input.is_action_pressed("move_down"):
		dir.y = 1
	elif Input.is_action_pressed("move_up"):
		dir.y = -1
		
	return dir
	
func update_animations(dir: Vector2):
	if dir == Vector2.ZERO:
		sprite.stop()
		return
	
	# Elegir animación según el vector
	if dir.x > 0: sprite.play("walk_right")
	elif dir.x < 0: sprite.play("walk_left")
	elif dir.y > 0: sprite.play("walk_down")
	elif dir.y < 0: sprite.play("walk_up")
	
	
	
	
