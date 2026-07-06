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
	if randi_range(0, 100) < 50:
		block_id = 1
	
	set_cell(Vector2i(x, y), 0, Vector2i(block_id, 0), flip_h_flag)

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
	
	#var still_has_pickaxes := false
	#for p in game.pickaxes:
		#if p != null:
			#still_has_pickaxes = true
			#break
	#
	#if still_has_pickaxes:
		#start_mining()
	#else:
		#game_over.emit()
	
#func add_pickaxe_actor(pick_actor: PickaxeActor, row: int):
	#var was_empty = tile_map.get_child_count() <= 0
	#tile_map.add_child(pick_actor)
	#var tile_size = tile_map.tile_set.tile_size.x
	#pick_actor.global_position.x = self.global_position.x + (column_offset * tile_size) - (tile_size / 2.0)
	#pick_actor.global_position.y = self.global_position.y + (row * tile_size) + (tile_size / 2.0)
	#pick_actor.timer.timeout.connect(_on_pickaxe_finished_mining.bind(pick_actor, row))
	#if was_empty:
		#start_mining()
	#
#func start_mining():
	#crack_drawing.queue_redraw()
	#pickaxes_remaining = tile_map.get_child_count()
	#for pick_actor in tile_map.get_children():
		#pick_actor.anim.play("mining")
		#pick_actor.timer.start()
	#
#func _on_pickaxe_finished_mining(pick_actor: PickaxeActor, row: int):
	#crack_drawing.queue_redraw()
	#var data = tile_map.get_cell_tile_data(Vector2i(column + column_offset, row))
	#if data:
		#var item = data.get_custom_data("item") as Item
		#game.add_item(item)
	#
	#tile_map.erase_cell(Vector2i(column + column_offset, row))
	#pick_actor.pickaxe_data.durability -= 1
	#
	#pickaxes_remaining -= 1
	#
	#if pick_actor.pickaxe_data.durability <= 0:
		#pick_actor.queue_free()
		#game.pickaxes[row] = null
	#
		#
	#if pickaxes_remaining <= 0:
		
