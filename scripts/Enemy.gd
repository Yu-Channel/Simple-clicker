extends Area2D


func _ready():
	pass # Replace with function body.


func _on_Enemy_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			print("clickしたよ！") # チェック用
#			queue_free()
			
