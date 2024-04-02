extends Node2D

onready var enemy_cooldown = $EnemyCooldown
onready var hp_label = $GUI/EnemyHP/HpNumLabel
onready var hp_bar = $GUI/EnemyHP/HpBar
onready var hp_bar_stylebox = $GUI/EnemyHP/HpBar.get("custom_styles/fg")
onready var power_button = $GUI/ButtonUI/VBox/PowerButton
onready var power_button_label = $GUI/ButtonUI/VBox/PowerButton/PowerButtonLabel

var enemy_node
var enemy_timer_node

func _ready():
	## debug log ##
	
	# タイマーの準備 と 敵の呼び出し
	enemy_cooldown.connect("timeout", self, "_on_EnemyCooldown_timeout")
	call_enemy()

# フレームごとの処理===================
func _process(delta):
	# 敵のHP関連の処理
	hp_label.text = str(Grobal.enemy_hp) + "/" + str(Grobal.enemy_max_hp)
	hp_bar.value = ( Grobal.enemy_hp / Grobal.enemy_max_hp ) * 100
	hp_bar_stylebox.bg_color = Color(1.0,(hp_bar.value / 100) , 0, 1)

# 敵の呼び出し 座標の設定===============
func call_enemy():
	enemy_node = load("res://scene/Enemy.tscn").instance()
	enemy_node.connect("tree_exited", self, "_on_Enemy_tree_exited")
	add_child(enemy_node)
	enemy_node.position.x = 260
	enemy_node.position.y = 200

## 敵を倒したときの処理
func _on_Enemy_tree_exited():
	# 敵が再表示されるまでの時間
	enemy_cooldown.start(0.6)
	# ボスで時間切れの場合は階層を進めない
	if Grobal.enemy_hp <= 0:
		Grobal.floor_num += 1

func _on_EnemyCooldown_timeout():
	call_enemy()

# ====================================


func _on_Button_pressed():
	# プレイヤーの強化
	
	# ボタンとラベルの表示の変更
	pass
