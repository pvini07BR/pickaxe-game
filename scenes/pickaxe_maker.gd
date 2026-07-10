extends PanelContainer

const PICKAXE_SLOT = preload("res://scenes/ui/pickaxe_slot.tscn")
const ITEM_SLOT = preload("res://scenes/ui/item_slot.tscn")

@export var inventory: Inventory
@export var pickaxe_list: PickaxeList
@export var heads: Array[HeadMaterial]
@export var handles: Array[HandleMaterial]

@onready var head_option: OptionButton = $VBoxContainer/HBoxContainer2/VBoxContainer/HeadContainer/OptionButton
@onready var handle_option: OptionButton = $VBoxContainer/HBoxContainer2/VBoxContainer/HandleContainer/OptionButton

@onready var head_texture: TextureRect = $VBoxContainer/HBoxContainer2/Control/HeadTexture
@onready var handle_texture: TextureRect = $VBoxContainer/HBoxContainer2/Control/HandleTexture

@onready var ingredients_container: GridContainer = $VBoxContainer/IngredientsContainer
@onready var missing_ingredients_text: Label = $VBoxContainer/MissingIngredientsText

var ingredients: Dictionary[Item, int]

func _ready() -> void:
	for head in heads:
		head_option.add_item(head.name)
		
	for handle in handles:
		handle_option.add_item(handle.name)
		
	head_texture.texture = heads[head_option.get_selected_id()].texture
	handle_texture.texture = handles[handle_option.get_selected_id()].texture

	calculate_ingredients()

func calculate_ingredients():
	ingredients.clear()
	for c in ingredients_container.get_children():
		c.queue_free()
	
	var head = heads[head_option.get_selected_id()]
	var handle = handles[handle_option.get_selected_id()]
	
	for i in head.ingredients:
		i = i as RecipeIngredient
		if ingredients.has(i.item):
			ingredients[i.item] += i.amount
		else:
			ingredients[i.item] = i.amount
			
	for i in handle.ingredients:
		i = i as RecipeIngredient
		if ingredients.has(i.item):
			ingredients[i.item] += i.amount
		else:
			ingredients[i.item] = i.amount
			
	for i in ingredients.keys():
		var slot = ITEM_SLOT.instantiate() as ItemSlot
		ingredients_container.add_child(slot)
		slot.set_item(i, ingredients[i])

func _on_head_option_selected(index: int) -> void:
	head_texture.texture = heads[index].texture
	calculate_ingredients()

func _on_handle_option_selected(index: int) -> void:
	handle_texture.texture = handles[index].texture
	calculate_ingredients()

func _on_make_pickaxe_button_pressed() -> void:
	var can_craft := true
	for item in ingredients:
		if inventory.inventory.has(item):
			if inventory.inventory[item] + 1 >= ingredients[item]:
				inventory.inventory[item] -= ingredients[item]
				if inventory.inventory[item] < 0:
					inventory.inventory.erase(item)
			else:
				can_craft = false
				break
		else:
			can_craft = false
			break
	
	if can_craft:
		missing_ingredients_text.visible = false
		inventory.refresh_inventory()
		var slot = PICKAXE_SLOT.instantiate() as PickaxeSlot
		var new_pick = Pickaxe.new()
		new_pick.head_material = heads[head_option.get_selected_id()]
		new_pick.handle_material = handles[handle_option.get_selected_id()]
		slot.pickaxe_data = new_pick
		pickaxe_list.add_child(slot)
	else:
		missing_ingredients_text.visible = true

func _on_close_button_pressed() -> void:
	self.visible = false
	missing_ingredients_text.visible = false
	get_parent().get_node("BGFade").visible = false
