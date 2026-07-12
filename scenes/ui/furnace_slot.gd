extends TextureProgressBar

class_name FurnaceSlot

@export var recipe: FurnaceRecipe = null
@export var inventory: Inventory

@onready var smelt_timer: Timer = $SmeltTimer

var hovered := false

signal started_smelting(slot: FurnaceSlot)
signal finished_smelting(slot: FurnaceSlot)

func _ready() -> void:
	self.visible = false

func begin_smelt():
	self.texture_under = recipe.output.icon
	self.texture_progress = recipe.output.icon
	self.tint_under = Color.hex(0x404040ff)
	smelt_timer.wait_time = recipe.smelt_time
	self.max_value = smelt_timer.wait_time
	self.value = smelt_timer.wait_time - smelt_timer.time_left
	self.visible = true
	smelt_timer.start()
	started_smelting.emit(self)
	
func _process(delta: float) -> void:
	if is_smelting():
		self.value = smelt_timer.wait_time - smelt_timer.time_left
		if hovered:
			Tooltip.show_tooltip(
				tr("PROGRESS")
				% [(self.value / self.max_value) * 100.0]
			)

func is_smelting() -> bool:
	return smelt_timer.time_left > 0.0

func _on_smelt_timer_timeout() -> void:
	self.visible = false
	inventory.add_item(self.recipe.output, 1)
	self.recipe = null
	self.value = 0.0
	self.tint_under = Color.hex(0xffffffff)
	finished_smelting.emit(self)

func _on_mouse_entered() -> void:
	hovered = true

func _on_mouse_exited() -> void:
	hovered = false
	Tooltip.hide_tooltip()
