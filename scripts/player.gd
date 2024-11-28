extends CharacterBody2D

const SPEED = 300.0

# Référence au AnimatedSprite2D
@onready var animation_player = $AnimatedSprite2D

# Stocker la dernière direction
var last_direction = "down"

var active_directions = []


func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO

	# Gérer l'entrée utilisateur
	if Input.is_action_just_pressed("ui_up"):
		active_directions.append("up")
	if Input.is_action_just_pressed("ui_down"):
		active_directions.append("down")
	if Input.is_action_just_pressed("ui_left"):
		active_directions.append("left")
	if Input.is_action_just_pressed("ui_right"):
		active_directions.append("right")

	if Input.is_action_just_released("ui_up"):
		active_directions.erase("up")
	if Input.is_action_just_released("ui_down"):
		active_directions.erase("down")
	if Input.is_action_just_released("ui_left"):
		active_directions.erase("left")
	if Input.is_action_just_released("ui_right"):
		active_directions.erase("right")

	# Déterminer la direction en fonction de la dernière action active
	if active_directions.size() > 0:
		match active_directions[-1]:  # Dernière action ajoutée
			"up":
				direction.y = -1
				last_direction = "up"
			"down":
				direction.y = 1
				last_direction = "down"
			"left":
				direction.x = -1
				last_direction = "left"
			"right":
				direction.x = 1
				last_direction = "right"

	# Mettre à jour la vélocité et déplacer le joueur
	velocity = direction * SPEED
	move_and_slide()

	# Gérer les animations
	if direction != Vector2.ZERO:
		animation_player.animation = "walk_" + last_direction
		animation_player.play()
	else:
		animation_player.animation = "idle_" + last_direction
		animation_player.play()
