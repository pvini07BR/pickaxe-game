extends Control

class_name PickaxeActor

@export var pickaxe_data: Pickaxe

@onready var head_sprite: TextureRect = $Head
@onready var handle_sprite: TextureRect = $Handle
@onready var progress_bar: ProgressBar = $ProgressBar

@onready var anim: AnimationPlayer = $AnimationPlayer

signal pickaxe_hit

func _ready() -> void:
	head_sprite.texture = pickaxe_data.head_material.texture
	handle_sprite.texture = pickaxe_data.handle_material.texture
	
	progress_bar.max_value = pickaxe_data.handle_material.durability
	progress_bar.value = pickaxe_data.durability
	pickaxe_data.durability_changed.connect(_on_durability_changed)
	
	anim.speed_scale = get_anim_speed_scale()
	
func get_anim_speed_scale() -> float:
	return (8.0 / 2.0) / pickaxe_data.head_material.mining_speed
	
func _on_durability_changed(value: int):
	progress_bar.value = value

func _on_pickaxe_hit():
	pickaxe_hit.emit()
