extends VBoxContainer

@export var game_window: GameWindow
@export var pickaxe_list: GridContainer

var active_rows: Array[PickaxeRow]

signal game_over

func _ready() -> void:
	for c in get_children():
		c = c as PickaxeRow
		c.pickaxe_added.connect(_on_pickaxe_added)
		c.pickaxe_removed.connect(_on_pickaxe_removed)
		c.finished_mining.connect(_on_pickaxe_finished.bind(c))
		
func _is_inventory_empty() -> bool:
	var valid_children = 0
	for child in pickaxe_list.get_children():
		if not child.is_queued_for_deletion():
			valid_children += 1
	return valid_children <= 0
		
func _on_pickaxe_added(row: PickaxeRow):
	if !active_rows.has(row):
		active_rows.push_back(row)
		
	row.start_mining()
	
func _on_pickaxe_removed(row: PickaxeRow):
	if active_rows.has(row):
		active_rows.erase(row)
		
		# This is needed for when you switch pickaxes
		# between rows, so it doesn't trigger a
		# game over right away
		await get_tree().process_frame
		
		var has_remaining_pickaxes := false
		var all_remaining_finished := true
		
		for c in get_children():
			var row_node = c as PickaxeRow
			if row_node and row_node != row and row_node.pickaxe_data:
				has_remaining_pickaxes = true
				if not row_node.finished:
					all_remaining_finished = false
					break
		
		if not has_remaining_pickaxes and _is_inventory_empty():
			game_over.emit()
				
		if has_remaining_pickaxes and all_remaining_finished:
			move_on()

func _on_pickaxe_finished(row: PickaxeRow):
	if active_rows.has(row):
		active_rows.erase(row)
		
	if active_rows.size() <= 0:
		move_on()
			
func move_on():
	if game_window.moving: return
	
	for c in get_children():
		if c is PickaxeRow:
			c.cracks.frame = 0
	
	active_rows.clear()
	game_window.move_to_next_column()
	await game_window.transition_over
	
	var still_has_one := false
	
	for c in get_children():
		var row_node = c as PickaxeRow
		if row_node and row_node.pickaxe_data:
			still_has_one = true
			active_rows.push_back(row_node)
			
	for row_node in active_rows:
		row_node.start_mining()
		
	if not still_has_one and _is_inventory_empty():
		game_over.emit()
