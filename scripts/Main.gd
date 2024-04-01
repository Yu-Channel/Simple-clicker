extends Node2D

onready var enemy_cooldown = $EnemyCooldown

var enemy_node
var enemy_timer_node

func _ready():
	# タイマーの準備 と 敵の呼び出し
	enemy_cooldown.connect("timeout", self, "_on_EnemyCooldown_timeout")
	call_enemy()

# 敵の呼び出し 座標の設定===============
func call_enemy():
	enemy_node = load("res://scene/Enemy.tscn").instance()
	enemy_node.connect("tree_exited", self, "_on_Enemy_tree_exited")
	add_child(enemy_node)
	enemy_node.position.x = 260
	enemy_node.position.y = 140

## 敵を倒したときの処理
func _on_Enemy_tree_exited():
	enemy_cooldown.start(0.6)
	Grobal.floor_num += 1

func _on_EnemyCooldown_timeout():
	call_enemy()

# ====================================
