extends Node2D

@export var noise_height_text: NoiseTexture2D

var noise: Noise

var width: int = 200
var height: int = 200

var offset = Vector2i(0, 0)

@onready var tile_map = $TileMap

@onready var tile_set = tile_map.tile_set
var water_atlas = 17

func _ready():
	noise = noise_height_text.noise
	generate_map()
	
func generate_map():
	var grass_water = []
	var grass_hill = []
	for x in range(-width/2, width/2):
		for y in range(-height/2, height/2):
			var noise_val = noise.get_noise_2d(x, y)
			var is_grass = false
			
			# Set water anyway
			tile_map.set_cell(0, Vector2i(x, y) +  offset, water_atlas, Vector2i(0, 0))
			
			if noise_val >= 0.0:
				is_grass = true
				grass_water.append(Vector2i(x, y) + offset)
				
			if noise_val >= 0.1 && is_grass:
				grass_hill.append(Vector2i(x, y) + offset)
			
	
	tile_map.set_cells_terrain_connect(1, grass_water, 0, 0)
	tile_map.set_cells_terrain_connect(2, grass_hill, 0, 1)
