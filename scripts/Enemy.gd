extends Area2D


func _ready():
	Grobal.enemy_max_hp = 10
	

func _on_Enemy_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			Grobal.enemy_max_hp -= 1
			print(str(Grobal.enemy_max_hp)) # チェック用
#			queue_free()
			
