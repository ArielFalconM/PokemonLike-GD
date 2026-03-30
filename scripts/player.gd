extends CharacterBody2D


@export var walk_speed: float = 6000.0
var current_interactable = null

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast: RayCast2D = $RayCast2D

#Funcion que maneja el movimiento general del player.
func _physics_process(delta: float) -> void:
	var direction := get_input_direction()
	
	velocity = direction.normalized() * walk_speed * delta
	move_and_slide()

	update_animations(direction)
	check_hover_interaction()
	
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
	
	#Apunta el RayCast a la direccion del player con modulo 1 bloque.
	ray_cast.target_position = dir * 16
	
	# Elegir animación según direccion actual.
	if dir.x > 0: sprite.play("walk_right")
	elif dir.x < 0: sprite.play("walk_left")
	elif dir.y > 0: sprite.play("walk_down")
	elif dir.y < 0: sprite.play("walk_up")
	

#Funcion que al RayCast detectar un cuerpo y el player interactue le pregunta al cuerpo si puede interactuar.
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if ray_cast.is_colliding():
			var target = ray_cast.get_collider()
			if target.has_method("interact"):
				target.interact()
		
		
func check_hover_interaction() -> void:
	if ray_cast.is_colliding():
		var new_target = ray_cast.get_collider()

		# Si el objeto que estamos viendo es distinto al que teníamos guardado...
		if new_target != current_interactable:
			
			# 1. Al objeto viejo le decimos que se oculte (si existía)
			if current_interactable and current_interactable.has_method("unhighlight"):
				current_interactable.unhighlight()
			
			# 2. Guardamos el nuevo objeto como el "actual"
			current_interactable = new_target

			# 3. Al nuevo objeto le decimos que se revele
			if current_interactable.has_method("highlight"):
				current_interactable.highlight()

	else: 
		# Si el RayCast no toca nada, pero antes sí tocaba algo...
		if current_interactable:
			if current_interactable.has_method("unhighlight"):
				current_interactable.unhighlight()
			current_interactable = null
