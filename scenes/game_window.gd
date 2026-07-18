extends TileMapLayer

class_name GameWindow

const WINDOW_SIZE := Vector2i(10, 6)

@export var column := 0
var moving := false

@export var seed := Tooltip.seed
@export var blockgens: Array[BlockGen]

signal seed_ready(seed: int)
signal transition_over

func _ready() -> void:
	if seed == 0:
		seed = randi()
		
	seed_ready.emit(seed)
	
	self.position.x -= tile_set.tile_size.x * column
	for y in WINDOW_SIZE.y:
		for x in WINDOW_SIZE.x:
			generate_block(column + x, y)

func generate_block(x: int, y: int) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed + hash(Vector2i(x, y))
	
	var block_id := 1
	
	for g in blockgens:
		var prob = g.get_spawn_probability(x)
		if rng.randf() < prob:
			block_id = g.block_id
			break
				
	var source := tile_set.get_source(0) as TileSetAtlasSource
	var tile_data := source.get_tile_data(Vector2i(block_id, 0), 0)
	
	if tile_data == null:
		return
		
	var blockdef := tile_data.get_custom_data("blockdef") as BlockDef
	if blockdef == null: 
		return
			
	var alternate := 0
	
	if blockdef.flip_h and rng.randf() < 0.5:
		alternate |= TileSetAtlasSource.TRANSFORM_FLIP_H
		
	if blockdef.flip_v and rng.randf() < 0.5:
		alternate |= TileSetAtlasSource.TRANSFORM_FLIP_V
	
	set_cell(
		Vector2i(x, y),
		0,
		Vector2i(block_id, 0),
		alternate
	)
	
func get_column() -> int:
	return column
	
func move_to_next_column():
	column += 1
	var t := create_tween()
	
	for y in WINDOW_SIZE.y:
		generate_block(column + WINDOW_SIZE.x - 1, y)
		
	moving = true
	t.tween_property(
		self,
		"position:x",
		self.position.x - tile_set.tile_size.x,
		0.5
	)
	await t.finished
	moving = false
	transition_over.emit()
	
	for y in WINDOW_SIZE.y:
		erase_cell(Vector2i(column - 1, y))
