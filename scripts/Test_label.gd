extends Label

var click_count = 0

func _on_Enemy_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			print("click event")
			click_count += 1
			text = str(click_count)
