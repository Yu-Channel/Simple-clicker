extends Node2D

var enemy_node

func _ready():
	call_enemy()

func call_enemy():
	enemy_node = load("res://scene/Enemy.tscn").instance()
	enemy_node.connect("tree_exited", self, "_on_Enemy_tree_exited")
	add_child(enemy_node)
	enemy_node.position.x = 260
	enemy_node.position.y = 140
	
func _on_Enemy_tree_exited():
	print("子ノードが消えたよ")

