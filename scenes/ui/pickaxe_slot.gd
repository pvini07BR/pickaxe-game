extends PanelContainer

class_name PickaxeSlot

@export var pickaxe_data: Pickaxe
@export var health_gradient: Gradient

@onready var handle_texture: TextureRect = $VBoxContainer/Control/Handle
@onready var head_texture: TextureRect = $VBoxContainer/Control/Head
@onready var durability_progbar: ProgressBar = $VBoxContainer/DurabilityProgressBar

@onready var game_window = get_tree().root.get_node("Main").game_window

var fill_stylebox: StyleBoxFlat

func _ready():
	fill_stylebox = durability_progbar.get_theme_stylebox("fill").duplicate()
	durability_progbar.add_theme_stylebox_override("fill", fill_stylebox)
	
	handle_texture.texture = pickaxe_data.handle_material.texture
	head_texture.texture = pickaxe_data.head_material.texture
	
	durability_progbar.max_value = pickaxe_data.handle_material.durability
	durability_progbar.value = pickaxe_data.durability
	
	pickaxe_data.durability_changed.connect(_on_pickaxe_durability_changed)
	_on_pickaxe_durability_changed(pickaxe_data.durability)
	
func _on_pickaxe_durability_changed(value: int):
	durability_progbar.value = value
	var ratio : float = remap(value, durability_progbar.min_value, durability_progbar.max_value, 0.0, 1.0)
	fill_stylebox.bg_color = health_gradient.sample(ratio)
		
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

func _on_mouse_entered() -> void:
	Tooltip.show_tooltip(
		tr("PICKAXE_HANDLE") + " " + tr(pickaxe_data.handle_material.name) + '\n' +
		tr("PICKAXE_HEAD") + ' ' + tr(pickaxe_data.head_material.name) + '\n' +
		tr("DURABILITY") + ' ' + str(pickaxe_data.durability) + '/' + str(pickaxe_data.handle_material.durability)
	)

func _on_mouse_exited() -> void:
	Tooltip.hide_tooltip()
