extends PanelContainer

const ITEM_SLOT = preload("res://scenes/ui/item_slot.tscn")

@export var recipes: Array[Recipe]

@onready var recipe_list: ItemList = $HBoxContainer/VBoxContainer2/RecipeList
@onready var ingredients_list: HBoxContainer = $HBoxContainer/VBoxContainer/IngredientsList

func _ready() -> void:
	for r in recipes:
		var i = recipe_list.add_item(r.output.name)
		recipe_list.set_item_icon(i, r.output.icon)
	recipe_list.select(0)
	_on_recipe_list_item_selected(0)

func _on_recipe_list_item_selected(index: int) -> void:
	for c in ingredients_list.get_children():
		c.queue_free()
		
	var recipe = recipes[index]
	for ingredient in recipe.ingredients:
		var slot = ITEM_SLOT.instantiate() as ItemSlot
		ingredients_list.add_child(slot)
		slot.set_item(ingredient.item, ingredient.amount)

func _on_close_button_pressed() -> void:
	self.visible = false
	get_parent().get_node("BGFade").visible = false

func _on_craft_button_pressed() -> void:
	if recipe_list.get_selected_items().size() > 0:
		var sel_recipe = recipes[recipe_list.get_selected_items()[0]]
		var can_craft := true
		
		var game = get_parent()
		
		for ingredient in sel_recipe.ingredients:
			if game.inventory.has(ingredient.item):
				if game.inventory[ingredient.item] + 1 >= ingredient.amount:
					game.inventory[ingredient.item] -= ingredient.amount
					if game.inventory[ingredient.item] < 0:
						game.inventory.erase(ingredient.item)
				else:
					can_craft = false
					break
			else:
				can_craft = false
				break
		
		if can_craft:
			game.add_item(sel_recipe.output)
			game.refresh_inventory()
		else:
			print("You don't have the ingredients!")
