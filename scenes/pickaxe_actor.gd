extends Control

class_name PickaxeActor

@export var pickaxe_data: Pickaxe
@export var health_gradient: Gradient

@onready var head_sprite: TextureRect = $Head
@onready var handle_sprite: TextureRect = $Handle
@onready var progress_bar: ProgressBar = $ProgressBar

@onready var anim: AnimationPlayer = $AnimationPlayer

var fill_stylebox: StyleBoxFlat

signal pickaxe_hit

func _ready() -> void:
	fill_stylebox = progress_bar.get_theme_stylebox("fill").duplicate()
	progress_bar.add_theme_stylebox_override("fill", fill_stylebox)
	
	head_sprite.texture = pickaxe_data.head_material.texture
	handle_sprite.texture = pickaxe_data.handle_material.texture
	
	progress_bar.max_value = pickaxe_data.handle_material.durability
	progress_bar.value = pickaxe_data.durability
	pickaxe_data.durability_changed.connect(_on_durability_changed)
		
	_on_durability_changed(pickaxe_data.durability)
		
func set_anim_speed_scale(factor: float):
	anim.speed_scale = ((8.0 / 2.0) / pickaxe_data.head_material.mining_speed) / factor
	
func _on_durability_changed(value: int):
	progress_bar.value = value
	var ratio : float = remap(value, progress_bar.min_value, progress_bar.max_value, 0.0, 1.0)
	fill_stylebox.bg_color = health_gradient.sample(ratio)
	
func _on_pickaxe_hit():
	pickaxe_hit.emit()
