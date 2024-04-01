extends Node2D

onready var enemy_cooldown = $EnemyCooldown

var enemy_node
var enemy_timer_node

func _ready():
	enemy_cooldown.connect("timeout", self, "_on_EnemyCooldown_timeout")
	call_enemy()

func call_enemy():
	enemy_node = load("res://scene/Enemy.tscn").instance()
	enemy_node.connect("tree_exited", self, "_on_Enemy_tree_exited")
	add_child(enemy_node)
	enemy_node.position.x = 260
	enemy_node.position.y = 140

func _on_Enemy_tree_exited():
	enemy_cooldown.start(3)

func _on_EnemyCooldown_timeout():
	call_enemy()

