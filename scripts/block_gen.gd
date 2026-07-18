extends Resource

class_name BlockGen

@export var block_id: int
@export var spawn_curve: Curve
@export var start_column := 0
@export var end_column := 100
@export var is_endless := false

func get_spawn_probability(current_column: int) -> float:
	if current_column < start_column:
		return 0.0
	
	if current_column > end_column:
		if is_endless:
			return spawn_curve.sample_baked(1.0)
		else:
			return 0.0
	
	var cycle_length = float(end_column - start_column)
	var local_progress = float(current_column - start_column) / cycle_length
	
	return spawn_curve.sample_baked(local_progress)
