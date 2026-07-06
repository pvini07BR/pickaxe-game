extends TileMapLayer

class_name GameWindow

const WINDOW_SIZE := Vector2i(10, 6)

var column := 0
var moving := false

@export var seed := 0

signal transition_over

func get_column() -> int:
	return column

func generate_block(x: int, y: int):
	seed(seed + hash(str(x) + "," + str(y)))
	
	var flip_h = randf() < 0.5
	var flip_h_flag = TileSetAtlasSource.TRANSFORM_FLIP_H if flip_h else 0
	
	var block_id = 0
	if randi_range(0, 100) < 15:
		block_id = 1
	
	set_cell(Vector2i(x, y), 0, Vector2i(block_id, -1 if block_id == -1 else 0), flip_h_flag)

func _ready() -> void:
	seed = randi()
	print("Seed: " + str(seed))
	
	for y in WINDOW_SIZE.y:
		for x in WINDOW_SIZE.x:
			generate_block(x, y)
			
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
