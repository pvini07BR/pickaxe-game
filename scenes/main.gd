extends Control

@onready var pickaxe_crafter: PanelContainer = $PickaxeCrafter
@onready var furnace: PanelContainer = $Furnace

@onready var bg_fade: ColorRect = $BGFade
@onready var game_over_popup: PanelContainer = $GameOverPopup

@onready var game_window: ColorRect = $MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/GameWindow
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and pickaxe_crafter.visible:
		bg_fade.visible = false
		pickaxe_crafter.missing_ingredients_text.visible = false
		pickaxe_crafter.visible = false
		
	if event.is_action_pressed("ui_cancel") and furnace.visible:
		bg_fade.visible = false
		furnace.visible = false

func _on_craft_pickaxe_button_pressed() -> void:
	bg_fade.visible = true
	pickaxe_crafter.visible = true

func _on_furnace_button_pressed() -> void:
	bg_fade.visible = true
	furnace.visible = true

func _on_game_over() -> void:
	bg_fade.visible = true
	pickaxe_crafter.visible = false
	furnace.visible = false
	game_over_popup.visible = true

func _on_new_game_button_pressed() -> void:
	get_tree().reload_current_scene()
