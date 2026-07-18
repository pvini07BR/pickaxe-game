extends Node

class_name Inventory

const ITEM_SLOT = preload("res://scenes/ui/item_slot.tscn")

@export var inventory: Dictionary[Item, int]
@export var inventory_gcontainer: GridContainer

func _ready() -> void:
	refresh_inventory()

func refresh_inventory():
	for c in inventory_gcontainer.get_children():
		c.queue_free()
	for item in inventory.keys():
		var slot = ITEM_SLOT.instantiate() as ItemSlot
		inventory_gcontainer.add_child(slot)
		slot.set_item(item, inventory[item] + 1)
		
func add_item(item: Item, amount: int):
	if !item: return
	if amount <= 0: return
	
	if inventory.has(item):
		inventory[item] += amount
	else:
		inventory[item] = amount - 1
	
	refresh_inventory()
	
func consume_ingredients(ingredients: Dictionary[Item, int]) -> bool:
	var can_craft := true
	for item in ingredients:
		if inventory.has(item):
			if inventory[item] + 1 >= ingredients[item]:
				inventory[item] -= ingredients[item]
				if inventory[item] < 0:
					inventory.erase(item)
			else:
				can_craft = false
				break
		else:
			can_craft = false
			break
			
	if can_craft:
		refresh_inventory()
			
	return can_craft
	
func consume_ingredients_array(ingredients: Array[RecipeIngredient]) -> bool:
	var can_craft := true
	for i in ingredients:
		if inventory.has(i.item):
			if inventory[i.item] + 1 >= i.amount:
				inventory[i.item] -= i.amount
				if inventory[i.item] < 0:
					inventory.erase(i.item)
			else:
				can_craft = false
				break
		else:
			can_craft = false
			break
		
	if can_craft:
		refresh_inventory()
			
	return can_craft
