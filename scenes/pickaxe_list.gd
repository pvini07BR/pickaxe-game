extends GridContainer

const PICKAXE_SLOT = preload("res://scenes/ui/pickaxe_slot.tscn")

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return not data["slot"] is PickaxeSlot
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	var pick_data = data["data"] as Pickaxe
	var row = data["slot"]
	
	if !row is PickaxeRow: return
	
	row = row as PickaxeRow
	
	var new_slot = PICKAXE_SLOT.instantiate() as PickaxeSlot
	new_slot.pickaxe_data = pick_data
	add_child(new_slot)
	
	row.pickaxe_data = null
