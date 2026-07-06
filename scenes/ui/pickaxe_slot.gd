extends PanelContainer

class_name PickaxeSlot

@export var pickaxe_data: Pickaxe

@onready var handle_texture: TextureRect = $MarginContainer/VBoxContainer/Control/Handle
@onready var head_texture: TextureRect = $MarginContainer/VBoxContainer/Control/Head
@onready var durability_progbar: ProgressBar = $MarginContainer/VBoxContainer/DurabilityProgressBar

@onready var game_window = get_tree().root.get_node("Main").game_window

func _ready():
	handle_texture.texture = pickaxe_data.handle_material.texture
	head_texture.texture = pickaxe_data.head_material.texture
	
	durability_progbar.max_value = pickaxe_data.handle_material.durability
	durability_progbar.value = pickaxe_data.durability
	
	tooltip_text = "Handle: %s\nHead: %s\nDurability: %d/%d" \
		% [
			pickaxe_data.handle_material.name,
			pickaxe_data.head_material.name,
			pickaxe_data.durability,
			pickaxe_data.handle_material.durability
		]
	
	pickaxe_data.durability_changed.connect(_on_pickaxe_durability_changed)
	
func _on_pickaxe_durability_changed(value: int):
	durability_progbar.value = value
		
func _get_drag_data(at_position: Vector2) -> Variant:
	if !pickaxe_data:
		return null
		
	var preview_container = Control.new()
	
	var handle_preview = TextureRect.new()
	handle_preview.texture = pickaxe_data.handle_material.texture
	
	var head_preview = TextureRect.new()
	head_preview.texture = pickaxe_data.head_material.texture
	
	preview_container.add_child(handle_preview)
	preview_container.add_child(head_preview)
	
	set_drag_preview(preview_container)
	
	return { "data": pickaxe_data, "slot": self }
