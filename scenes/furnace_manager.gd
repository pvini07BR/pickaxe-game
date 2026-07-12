extends Control

const ITEM_SLOT = preload("res://scenes/ui/item_slot.tscn")
const FURNACE_SLOT = preload("res://scenes/ui/furnace_slot.tscn")

@export var furnace_ingredients: Dictionary[Item, int]
@export var recipes: Array[FurnaceRecipe]
@export var inventory: Inventory

@onready var recipe_list: ItemList = $PanelContainer/FurnaceUI/VBoxContainer/RecipeList
@onready var furnaces_grid: GridContainer = $PanelContainer/FurnaceUI/VBoxContainer2/HBoxContainer2/VBoxContainer/PanelContainer/ScrollContainer/FurnacesGrid
@onready var furnace_ingredients_cont: HBoxContainer = $PanelContainer/FurnaceUI/VBoxContainer2/HBoxContainer2/VBoxContainer2/FurnaceIngredients

@onready var ingredients_grid: GridContainer = $PanelContainer/FurnaceUI/VBoxContainer2/VBoxContainer/HBoxContainer/VBoxContainer/IngredientsGridContainer
@onready var smelt_time_label: Label = $PanelContainer/FurnaceUI/VBoxContainer2/VBoxContainer/HBoxContainer/SmeltTimeLabel
@onready var output_slot: ItemSlot = $PanelContainer/FurnaceUI/VBoxContainer2/VBoxContainer/HBoxContainer/VBoxContainer3/OutputSlot
@onready var smelt_button: Button = $PanelContainer/FurnaceUI/VBoxContainer2/VBoxContainer/SmeltButton

@onready var missing_furnace_ing_label: Label = $PanelContainer/FurnaceUI/VBoxContainer2/HBoxContainer2/VBoxContainer2/MissingFurnaceIngLabel
@onready var missing_smelt_ing_label: Label = $PanelContainer/FurnaceUI/VBoxContainer2/VBoxContainer/MissingSmeltIngLabel

func _ready() -> void:
	for ingredient in furnace_ingredients.keys():
		var slot = ITEM_SLOT.instantiate() as ItemSlot
		furnace_ingredients_cont.add_child(slot)
		slot.set_item(ingredient, furnace_ingredients[ingredient])
	
	update_furnace_button()
	
	for recipe in recipes:
		recipe_list.add_item(recipe.output.name, recipe.output.icon)
	
	recipe_list.select(0)
	_on_recipe_list_item_selected(0)
	
func update_furnace_button():
	var available_furnaces := 0
	for f in furnaces_grid.get_children():
		f = f as FurnaceSlot
		if !f.is_smelting(): available_furnaces += 1
	
	if available_furnaces > 0:
		smelt_button.text = tr("BTN_SMELT_ITEM") % available_furnaces
		smelt_button.disabled = false
	else:
		smelt_button.text = tr("BTN_SMELT_NO_FURNACES")
		smelt_button.disabled = true
	
func _on_recipe_list_item_selected(index: int) -> void:
	for c in ingredients_grid.get_children():
		c.queue_free()
		
	var recipe = recipes[recipe_list.get_selected_items()[0]] as FurnaceRecipe
		
	for i in recipe.ingredients:
		i = i as RecipeIngredient
		var slot = ITEM_SLOT.instantiate() as ItemSlot
		ingredients_grid.add_child(slot)
		slot.set_item(i.item, i.amount)
		
	smelt_time_label.text = tr("LABEL_SMELTING_TIME") % recipe.smelt_time
	
	output_slot.set_item(recipe.output, 1)
	
func _on_smelt_button_pressed() -> void:
	var slot: FurnaceSlot = null
	for f in furnaces_grid.get_children():
		f = f as FurnaceSlot
		if !f.is_smelting():
			slot = f
			break
			
	if slot:
		var recipe = recipes[recipe_list.get_selected_items()[0]] as FurnaceRecipe
		var can_smelt = inventory.consume_ingredients_array(recipe.ingredients)
		if can_smelt:
			missing_smelt_ing_label.visible = false
			slot.recipe = recipe
			slot.begin_smelt()
		else:
			missing_smelt_ing_label.visible = true
	
func _on_craft_furnace_button_pressed() -> void:
	var can_craft = inventory.consume_ingredients(furnace_ingredients)
	if can_craft:
		missing_furnace_ing_label.visible = false
		var slot = FURNACE_SLOT.instantiate() as FurnaceSlot
		furnaces_grid.add_child(slot)
		slot.started_smelting.connect(_on_furnace_slot_smelt_begin)
		slot.finished_smelting.connect(_on_furnace_slot_finished_smelting)
		slot.inventory = inventory
	else:
		missing_furnace_ing_label.visible = true
	
func _on_furnace_slot_smelt_begin(slot: FurnaceSlot):
	update_furnace_button()
	
func _on_furnace_slot_finished_smelting(slot: FurnaceSlot):
	update_furnace_button()

func _on_close_button_pressed() -> void:
	self.visible = false
	missing_furnace_ing_label.visible = false
	missing_smelt_ing_label.visible = false
	get_parent().get_node("BGFade").visible = false

func _on_furnaces_grid_child_entered_tree(node: Node) -> void:
	if !is_node_ready(): return
	
	await get_tree().process_frame
	
	update_furnace_button()

func _on_furnaces_grid_child_exiting_tree(node: Node) -> void:
	if !is_node_ready(): return
	
	await get_tree().process_frame
	
	update_furnace_button()
