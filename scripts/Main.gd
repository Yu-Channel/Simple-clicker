extends Node2D

onready var enemy_cooldown = $EnemyCooldown
onready var hp_label = $GUI/EnemyHP/HpNumLabel
onready var hp_bar = $GUI/EnemyHP/HpBar
onready var hp_bar_stylebox = $GUI/EnemyHP/HpBar.get("custom_styles/fg")
onready var power_button = $GUI/ButtonUI/VBox/PowerButton
onready var power_button_label = $GUI/ButtonUI/VBox/PowerButtonLabel
onready var auto_power_button = $GUI/ButtonUI/VBox/AutoPowerButton
onready var auto_power_button_label = $GUI/ButtonUI/VBox/AutoPowerButtonLabel

var enemy_node
var enemy_timer_node
var click_power_price:float
var auto_click_power_price:float
var frame60:float

func _ready():
	## debug log ##
	
	# タイマーの準備 と 敵の呼び出し
	enemy_cooldown.connect("timeout", self, "_on_EnemyCooldown_timeout")
	call_enemy()

# フレームごとの処理===================
func _process(_delta):
	# フレームの計測(60fps)
	frame60 += 1
	if frame60 >= 60:
		frame60 = 0
	
	# 敵のHP関連の処理
	hp_label.text = str(Grobal.enemy_hp) + "/" + str(Grobal.enemy_max_hp)
	hp_bar.value = ( Grobal.enemy_hp / Grobal.enemy_max_hp ) * 100
	hp_bar_stylebox.bg_color = Color(1.0,(hp_bar.value / 100) , 0, 1)
	# お買い物の自動更新
	shop_price()
	
	# オートクリックの判定
	if !(frame60) && (Grobal.enemy_hp > 0):
		Grobal.enemy_hp -= Grobal.auto_click_power

# 敵の呼び出し 座標の設定===============
func call_enemy():
	enemy_node = load("res://scene/Enemy.tscn").instance()
	enemy_node.connect("tree_exited", self, "_on_Enemy_tree_exited")
	enemy_node.connect("input_event", self, "_on_Enemy_input_event")
	add_child(enemy_node)
	enemy_node.position.x = 260
	enemy_node.position.y = 160

## 敵を倒したときの処理
func _on_Enemy_tree_exited():
	# 敵が再表示されるまでの時間
	enemy_cooldown.start(0.6)
	# ボスで時間切れの場合は階層を進めない
	if Grobal.enemy_hp <= 0:
		Grobal.floor_num += 1

func _on_EnemyCooldown_timeout():
	call_enemy()

# 敵をクリックしたらパーティクルを生成
func _on_Enemy_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			var click_particles_node = load("res://scene/ClickParticles.tscn").instance()
			click_particles_node.connect("tree_exited", self, "_on_ClickParticles_tree_exited")
			
			# マウスカーソルの座標を取得
			var mouse_position:Vector2 = get_viewport().get_mouse_position()
			click_particles_node.position = mouse_position
			
			add_child(click_particles_node)
			

# ====================================

# ボタンを押したときの処理
func _on_PowerButton_pressed():
	# お金が足りてるかどうか
	shop_price()
	if click_power_price <= Grobal.money:
		# お金の消費
		Grobal.money -= int(click_power_price)
		# プレイヤーの強化
		Grobal.click_power += 1

func _on_AutoPowerButton_pressed():
	# お金が足りてるかどうか
	shop_price()
	if auto_click_power_price <= Grobal.money:
		# お金の消費
		Grobal.money -= int(auto_click_power_price)
		# プレイヤーの強化
		Grobal.auto_click_power += 1

# 各お買い物の計算と表示の更新
func shop_price():
	# 各種お値段の計算
	click_power_price = int(100 * (pow(Grobal.click_power, 1.32)))
	auto_click_power_price = int(500 * (pow(1 + Grobal.auto_click_power, 1.48)))
	
	# ボタンとラベルの表示の変更
	power_button.text = "Power +" + str(1) + "(" + str(Grobal.click_power) + ")"
	power_button_label.text = "Money x" + str(click_power_price)
	auto_power_button.text = "AutoPower +" + str(1) + "(" + str(Grobal.auto_click_power) + ")"
	auto_power_button_label.text = "Money x" + str(auto_click_power_price)


