extends CharacterBody2D

const SPEED = 300.0

# Référence au AnimatedSprite2D
@onready var animation_player = $AnimatedSprite2D

# Reference to Camera2D
@onready var camera: Camera2D = $Camera2D

# Zoom configuration
@export var min_zoom: float = 0.5
@export var max_zoom: float = 3.0
@export var zoom_step: float = 0.1

# Stocker la dernière direction
var last_direction = "down"

var active_directions = []


func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO

	# Gérer l'entrée utilisateur
	if Input.is_action_just_pressed("move_up"):
		active_directions.append("up")
	if Input.is_action_just_pressed("move_down"):
		active_directions.append("down")
	if Input.is_action_just_pressed("move_left"):
		active_directions.append("left")
	if Input.is_action_just_pressed("move_right"):
		active_directions.append("right")

	if Input.is_action_just_released("move_up"):
		active_directions.erase("up")
	if Input.is_action_just_released("move_down"):
		active_directions.erase("down")
	if Input.is_action_just_released("move_left"):
		active_directions.erase("left")
	if Input.is_action_just_released("move_right"):
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
	
	handle_zoom()


func handle_zoom():
	# Zoom in and out using mouse wheel
	if Input.is_action_just_pressed("scroll_down"):
		camera.zoom -= Vector2(zoom_step, zoom_step)
		camera.zoom.x = clamp(camera.zoom.x, min_zoom, max_zoom)
		camera.zoom.y = clamp(camera.zoom.y, min_zoom, max_zoom)
	elif Input.is_action_just_pressed("scroll_up"):
		camera.zoom += Vector2(zoom_step, zoom_step)
		camera.zoom.x = clamp(camera.zoom.x, min_zoom, max_zoom)
		camera.zoom.y = clamp(camera.zoom.y, min_zoom, max_zoom)
