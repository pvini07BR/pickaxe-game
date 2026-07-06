extends Resource

class_name Pickaxe

signal durability_changed(value: int)
		
var durability: int:
	set(value):
		durability_changed.emit(value)
		durability = value

@export var head_material: HeadMaterial
@export var handle_material: HandleMaterial:
	set(value):
		durability = value.durability
		handle_material = value
