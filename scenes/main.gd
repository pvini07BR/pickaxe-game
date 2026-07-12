extends Control

@onready var pickaxe_crafter: PanelContainer = $PickaxeCrafter
@onready var furnace: Control = $FurnaceManager

@onready var bg_fade: ColorRect = $BGFade
@onready var game_over_popup: PanelContainer = $GameOverPopup

@onready var game_window: ColorRect = $MarginContainer/HBoxContainer/VBoxContainer/MarginContainer/GameWindow

@onready var language: PanelContainer = $Language
@onready var tutorial: PanelContainer = $Tutorial
@onready var credits: PanelContainer = $Credits
@onready var reset: PanelContainer = $ResetMenu
@onready var seed_label: Label = $VBoxContainer/SeedLabel
@onready var seed_spin_box: SpinBox = $ResetMenu/VBoxContainer/HBoxContainer2/SeedSpinBox

func _init() -> void:
	TranslationServer.set_locale("english")
	
func _ready() -> void:
	if !Tooltip.language_defined:
		bg_fade.visible = true
		language.visible = true
		Tooltip.language_defined = true
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if pickaxe_crafter.visible:
			bg_fade.visible = false
			pickaxe_crafter.missing_ingredients_text.visible = false
			pickaxe_crafter.visible = false
		
		if furnace.visible:
			bg_fade.visible = false
			furnace.visible = false
		
		if tutorial.visible:
			bg_fade.visible = false
			tutorial.visible = false
			
		if language.visible:
			bg_fade.visible = false
			language.visible = false
			
		if reset.visible:
			bg_fade.visible = false
			reset.visible = false
			
		if credits.visible:
			bg_fade.visible = false
			credits.visible = false

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
	Tooltip.seed = seed_spin_box.value
	get_tree().reload_current_scene()

func _on_language_button_pressed() -> void:
	bg_fade.visible = true
	language.visible = true

func _on_how_to_play_button_pressed() -> void:
	bg_fade.visible = true
	tutorial.visible = true
	
func _on_close_tutorial_pressed() -> void:
	tutorial.visible = false
	bg_fade.visible = false

func _on_credits_button_pressed() -> void:
	credits.visible = true
	bg_fade.visible = true

func _on_close_credits_button_pressed() -> void:
	credits.visible = false
	bg_fade.visible = false

func _on_credits_richtext_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))

func _on_reset_button_pressed() -> void:
	reset.visible = true
	bg_fade.visible = true

func _on_reset_cancel_button_pressed() -> void:
	reset.visible = false
	bg_fade.visible = false

func _on_tile_map_layer_seed_ready(seed: int) -> void:
	await get_tree().process_frame
	seed_label.text = "Seed: %d" % seed
