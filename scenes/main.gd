extends Control

const ITEM_SLOT = preload("res://scenes/ui/item_slot.tscn")

@export var inventory: Dictionary[Item, int]

@onready var inventory_gcontainer: GridContainer = $HBoxContainer/VBoxContainer2/Inventory/PanelContainer/MarginContainer/GridContainer
@onready var pickaxes_gcontainer: GridContainer = $HBoxContainer/VBoxContainer2/Pickaxes/PanelContainer/MarginContainer/GridContainer

@onready var crafting_window: PanelContainer = $CraftingWindow
@onready var bg_fade: ColorRect = $BGFade
@onready var game_over_popup: PanelContainer = $GameOverPopup

@onready var game_window: ColorRect = $HBoxContainer/VBoxContainer/MarginContainer/GameWindow

func refresh_inventory():
	for c in inventory_gcontainer.get_children():
		c.queue_free()
	for item in inventory.keys():
		var slot = ITEM_SLOT.instantiate() as ItemSlot
		inventory_gcontainer.add_child(slot)
		slot.set_item(item, inventory[item])

func _ready() -> void:
	refresh_inventory()

func add_item(item: Item):
	if inventory.has(item):
		inventory[item] += 1
	else:
		inventory[item] = 0
		
	refresh_inventory()

func _on_crafting_button_pressed() -> void:
	bg_fade.visible = true
	crafting_window.visible = true

func _on_game_over() -> void:
	bg_fade.visible = true
	crafting_window.visible = false
	game_over_popup.visible = true

func _on_new_game_button_pressed() -> void:
	get_tree().reload_current_scene()
