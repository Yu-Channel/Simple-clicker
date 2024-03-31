extends Node2D

var enemy_node

func _ready():
	enemy_node = load("res://scene/Enemy.tscn").instance()
	add_child(enemy_node)
	enemy_node.position.x = 260
	enemy_node.position.y = 140



