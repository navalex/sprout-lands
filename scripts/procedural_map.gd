extends Node2D

@export var noise_height_text: NoiseTexture2D

var noise: Noise

var width: int = 190
var height: int = 108

var offset = Vector2i(0, 0)

@onready var tile_map = $TileMap
@onready var tile_set = tile_map.tile_set

var water_atlas = 17

func _ready():
	noise = noise_height_text.noise
	generate_map()

func generate_map():
	# Utiliser des tableaux standards
	var grass_water: Array[Vector2i] = []
	var grass_hill: Array[Vector2i] = []

	# Précalculer les limites
	var start_x = -int(width / 2)
	var end_x = int(width / 2)
	var start_y = -int(height / 2)
	var end_y = int(height / 2)

	for x in range(start_x, end_x):
		for y in range(start_y, end_y):
			var position = Vector2i(x, y) + offset
			var noise_val = noise.get_noise_2d(x, y)

			# Placer l'eau
			tile_map.set_cell(0, position, water_atlas, Vector2i(0, 0))

			# Déterminer les types de terrain
			if noise_val >= 0.0:
				grass_water.append(position)
			if noise_val >= 0.1:
				grass_hill.append(position)

	# Utiliser les appels de batch pour les terrains
	tile_map.set_cells_terrain_connect(1, grass_water, 0, 0)
	tile_map.set_cells_terrain_connect(2, grass_hill, 0, 1)
