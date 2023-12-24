extends Control

@onready var list = $ItemList
@onready var image = $TextureRect
@onready var description = $Label

var items = [
	{"name": "Item 0", "image_path": "res://inventory_image_default_texture.png", "description": "Description for Item 0"},
	{"name": "Item 1", "image_path": "res://inventory_image_default_texture.png", "description": "Description for Item 1"},
	{"name": "Item 2", "image_path": "res://inventory_image_default_texture.png", "description": "Description for Item 2"},
	{"name": "Item 3", "image_path": "res://inventory_image_default_texture.png", "description": "Description for Item 3"},
	{"name": "Item 4", "image_path": "res://inventory_image_default_texture.png", "description": "Description for Item 4"},
	{"name": "Item 5", "image_path": "res://inventory_image_default_texture.png", "description": "Description for Item 5"},
	{"name": "Item 6", "image_path": "res://inventory_image_default_texture.png", "description": "Description for Item 6"},
	{"name": "Item 7", "image_path": "res://inventory_image_default_texture.png", "description": "Description for Item 7"},
]

var selected_item_index = 0
signal item_selected(item_index)

func _ready():
	update_item_list()


func _input(event):
	if event.is_action_pressed("ui_accept"):
		use_selected_item()


func update_item_list():
	list.clear_items()
	for item in items:
		list.add_item_to_list(item["name"])


func use_selected_item():
	var selected_item = items[selected_item_index]
	
	print("Using item: ", selected_item["name"])
	
	image.texture = load(selected_item["image_path"])
	description.text = selected_item["description"]


func _on_item_list_item_selected(index):
	selected_item_index = index
	use_selected_item()
