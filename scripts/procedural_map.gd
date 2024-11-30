extends Node2D

@export var noise_height_text: NoiseTexture2D

var noise: Noise

var width: int = 1000
var height: int = 1000

var chunk_size: int = 10

var offset = Vector2i(0, 0)

@onready var tile_map = $TileMap
@onready var tile_set = tile_map.tile_set
@export var loading_screen: Control
@onready var progress_bar: ProgressBar

var water_atlas = 17

func _ready():
	noise = noise_height_text.noise
	loading_screen.visible = true
	progress_bar = loading_screen.get_node("ProgressBar")
	
	progress_bar.value = 0
	await generate_noise_chunks()  # Call the asynchronous map generation function
	print("Map generation complete!")

func generate_noise_chunks():
	var current: int = 0
	var chunk_map: Array[Array] = []

	for x in range(-width / 2, width / 2, chunk_size):
		for y in range(-height / 2, height / 2, chunk_size):
			chunk_map.append(make_chunk(x, y))
	
	await generate_layer(chunk_map, -2.0, 0, 0, 0, 3, 0)
	await generate_layer(chunk_map, 0.0, 1, 0, 1, 3, 1)
	await generate_layer(chunk_map, 0.1, 2, 0, 2, 3, 2)

func generate_layer(chunk_map: Array[Array], threshold: float, layer_id: int, terrain_set: int, terrain_id: int, step_size: int, step_number: int):
	var chunk_nb = 1
	var layer_size = chunk_map.size()
	for chunk in  chunk_map:
		var tile_chunk: Array[Vector2i] = []
		for pos in chunk:
			var noise_val = noise.get_noise_2d(pos.x - width / 2, pos.y - height / 2)
			if (threshold == -2):
				tile_map.set_cell(0, pos, water_atlas, Vector2i(0, 0))
			
			if (threshold != -2 && noise_val >= threshold):
				tile_chunk.append(pos)
		tile_map.set_cells_terrain_connect(layer_id, tile_chunk, terrain_set, terrain_id)
		progress_bar.value = float( ( float(step_number) * float(layer_size) + float(chunk_nb) ) / ( float(layer_size) * float(step_size) ) ) * 100
		
		chunk_nb += 1
		await get_tree().process_frame

func make_chunk(x: int, y: int) -> Array[Vector2i]:
	var chunk: Array[Vector2i] = []
	for cx in range(chunk_size):
		for cy in range(chunk_size):
			chunk.append(Vector2i(x + cx, y + cy))
	return chunk
