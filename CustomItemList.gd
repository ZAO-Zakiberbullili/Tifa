extends ItemList

func add_item_to_list(item_name):
	# var item_label = Label.new()
	# item_label.text = item_name
	# add_child(item_label)
	
	add_item(item_name)
	

func clear_items():
	# while get_child_count() > 0:
		# get_child(0).queue_free()
		
	clear()
