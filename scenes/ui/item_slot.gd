extends PanelContainer

class_name ItemSlot

@onready var texture: TextureRect = $MarginContainer/TextureRect
@onready var number_label: Label = $NumberLabel

func set_item(item: Item, amount: int):
	if amount > 1:
		tooltip_text = item.name + " (" + str(amount) + ")"
	else:
		tooltip_text = item.name
		
	texture.texture = item.icon
	if amount > 1:
		number_label.text = str(amount)
	else:
		number_label.text = ""
