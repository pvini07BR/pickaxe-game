extends ColorRect

class_name PickaxeRow

const PICKAXE_ACTOR = preload("res://scenes/pickaxe_actor.tscn")
const PICK_BREAK_PARTICLES = preload("res://scenes/pickaxe_break_particles.tscn")

@export var game_window: GameWindow

var actor: PickaxeActor = null
var finished := false

@onready var game = get_tree().root.get_node("Main")
@onready var cracks: Sprite2D = $Cracks
@onready var particles: CPUParticles2D = $Particles

signal pickaxe_added(row: PickaxeRow)
signal pickaxe_removed(row: PickaxeRow)
signal finished_mining

var pickaxe_data: Pickaxe = null:
	set(value):
		if is_node_ready():
			if value:
				actor = PICKAXE_ACTOR.instantiate() as PickaxeActor
				actor.pickaxe_data = value
				actor.pickaxe_hit.connect(_on_pickaxe_hit)
				add_child(actor)
				
				particles.lifetime = (actor.anim.get_animation("mining").length * actor.get_anim_speed_scale()) / 4.0
				pickaxe_added.emit(self)
			else:
				if actor: actor.queue_free()
				pickaxe_removed.emit(self)
		pickaxe_data = value
		
func start_mining():
	if not actor: return
	
	finished = false
	var block_atlas_coords = game_window.get_cell_atlas_coords(Vector2i(game_window.column, get_index()))
	if block_atlas_coords.x == -1 and block_atlas_coords.y == -1:
		# This timer fixes some weird concurrency bug I couldn't figure out
		await get_tree().create_timer(0.1).timeout
		actor.anim.stop()
		finished_mining.emit()
		finished = true
	else:
		actor.anim.play("mining")

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if not data is Dictionary or not data.has("slot"):
		return false
		
	var slot = data["slot"]
	var is_valid = pickaxe_data == null and not game_window.moving
	
	if is_valid:
		color.a = 0.5
	else:
		color.a = 0
		
	return is_valid
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	if game_window.moving:
		return
		
	color.a = 0
	
	var slot = data["slot"]
	var pick_data = data["data"] as Pickaxe
	
	if slot is PickaxeSlot:
		slot = slot as PickaxeSlot
		slot.queue_free()
	elif slot is PickaxeRow:
		slot = slot as PickaxeRow
		slot.pickaxe_data = null
		
	pickaxe_data = pick_data
	
func _get_drag_data(at_position: Vector2) -> Variant:
	if !pickaxe_data or game_window.moving:
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
	
func _on_pickaxe_hit():
	var block_atlas_coords = game_window.get_cell_atlas_coords(Vector2i(game_window.column, get_index()))
	var mat = particles.material as ShaderMaterial
	mat.set_shader_parameter("atlas_id", block_atlas_coords.x)
	particles.emitting = true
	
	if cracks.frame < 7:
		cracks.frame += 1
		await actor.anim.animation_finished
		actor.anim.play("mining")
	else:
		var data = game_window.get_cell_tile_data(Vector2i(game_window.column, get_index()))
		if data:
			var item = data.get_custom_data("item") as Item
			game.add_item(item)
			
		game_window.erase_cell(Vector2i(game_window.column, get_index()))
		cracks.frame = 0
		
		await actor.anim.animation_finished
		
		randomize()
		cracks.flip_h = randi() % 2
		cracks.flip_v = randi() % 2
		pickaxe_data.durability -= 1
		if pickaxe_data.durability <= 0:
			var pick_parts = PICK_BREAK_PARTICLES.instantiate()
			pick_parts.pick_data = pickaxe_data
			add_child(pick_parts)
			pickaxe_data = null
		else:
			actor.anim.stop()
		finished_mining.emit()
		finished = true
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		color.a = 0

func _on_mouse_exited() -> void:
	color.a = 0
