extends Control

class_name PickaxeActor

@export var pickaxe_data: Pickaxe

@onready var head_sprite: TextureRect = $Head
@onready var handle_sprite: TextureRect = $Handle
@onready var progress_bar: ProgressBar = $ProgressBar

@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	head_sprite.texture = pickaxe_data.head_material.texture
	handle_sprite.texture = pickaxe_data.handle_material.texture
	
	#timer.wait_time = pickaxe_data.head_material.mining_speed
	#anim.speed_scale = anim.get_animation("mining").length * 2 / timer.wait_time

	progress_bar.max_value = pickaxe_data.handle_material.durability
	progress_bar.value = pickaxe_data.durability
	pickaxe_data.durability_changed.connect(_on_durability_changed)
	
func _on_durability_changed(value: int):
	progress_bar.value = value
