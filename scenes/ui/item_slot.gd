extends PanelContainer

class_name ItemSlot

@export var item: Item
@export var amount: int = 0

@onready var texture: TextureRect = $TextureRect
@onready var number_label: Label = $NumberLabel

func _ready() -> void:
	if item and amount > 0:
		set_item(item, amount)

func set_item(new_item: Item, new_amount: int):
	if !new_item: return
	
	item = new_item
	amount = new_amount
		
	texture.texture = item.icon
	if amount > 1:
		number_label.text = str(amount)
	else:
		number_label.text = ""

func _on_mouse_entered() -> void:
	if item:
		if amount > 1:
			Tooltip.show_tooltip(tr(item.name) + " (" + str(amount) + ")")
		else:
			Tooltip.show_tooltip(item.name)

func _on_mouse_exited() -> void:
	Tooltip.hide_tooltip()
