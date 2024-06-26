extends Node2D

onready var enemy_node = $Enemy
onready var enemy_cooldown = $Enemy/EnemyCooldown

onready var hp_label = $GUI/EnemyHP/HpNumLabel
onready var hp_bar = $GUI/EnemyHP/HpBar
onready var hp_bar_stylebox = $GUI/EnemyHP/HpBar.get("custom_styles/fg")
onready var power_button = $GUI/ButtonUI/VBox/PowerButton
onready var power_button_label = $GUI/ButtonUI/VBox/PowerButtonLabel
onready var auto_power_button = $GUI/ButtonUI/VBox/AutoPowerButton
onready var auto_power_button_label = $GUI/ButtonUI/VBox/AutoPowerButtonLabel
onready var farm_mode = $GUI/FarmModeCheckBox

onready var hud_timer_bar = $HUD/TimerBar
onready var hud_iimer_label = $HUD/TimerBar/Label
onready var hud_floor_label = $HUD/FloorLabel
onready var hud_money_label = $HUD/MoneyLabel
onready var hud_number_label = $HUD/MoneyNumberLabel

enum ThousandsSparatorUnit { null, K, M, G, T, P, E, Z, Y, R, Q }

var enemy_add_node
var enemy_timer_node
var click_power_price:float
var auto_click_power_price:float
var frame60:float

func _ready():
	## debug log ##
	
	load_file()
	# タイマーの準備 と 敵の呼び出し
	enemy_cooldown.connect("timeout", self, "_on_EnemyCooldown_timeout")
	call_enemy()
	
	hud_floor_label.text = str(Grobal.floor_num) + "F"
	


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
	
	# ボスタイマーの処理
	hud_timer_bar.value = Grobal.time_limit / Grobal.LIMIT_TIMER_NUM * 100
	hud_iimer_label.text = "%.2fs" % [Grobal.time_limit]
	
	# お買い物の自動更新
	shop_price()
	
	# お金のラベルを更新
	hud_number_label.text = (str(unit_conversion(Grobal.money)))
	
	# オートクリックの判定
	if !(frame60) && (Grobal.enemy_hp > 0):
		Grobal.enemy_hp -= Grobal.auto_click_power

# 敵の呼び出し 座標の設定===============
func call_enemy():
	enemy_add_node = load("res://scene/Enemy.tscn").instance()
	enemy_add_node.connect("tree_exited", self, "_on_Enemy_tree_exited")
	enemy_add_node.connect("input_event", self, "_on_Enemy_input_event")
	
	enemy_node.add_child(enemy_add_node)
	enemy_add_node.position.x = 260
	enemy_add_node.position.y = 160
	
	match Grobal.floor_num % 10:
		0:
			hud_timer_bar.show()
		_:
			hud_timer_bar.hide()

## 敵を倒したときの処理
func _on_Enemy_tree_exited():
	# 敵が再表示されるまでの時間
	enemy_cooldown.start(0.6)
	
	if farm_mode.pressed == false:
		Grobal.farm_mode_flag = 0
	else:
		Grobal.farm_mode_flag = 1
	
	# ボスで時間切れの場合は階層を進めない
	# もしファームモードがONならループ
	if Grobal.farm_mode_flag != 0:
		# ボス前フロアだった場合
		if (Grobal.floor_num % 10 == 9):
			pass
		elif (Grobal.floor_num % 10 == 0 and Grobal.enemy_hp > 0):
			Grobal.floor_num -= 1
		else:
			Grobal.floor_num += 1
		
	elif Grobal.enemy_hp <= 0:
			Grobal.floor_num += 1
	
	hud_floor_label.text = str(Grobal.floor_num) + "F"
	
	
func _on_EnemyCooldown_timeout():
	call_enemy()

# 敵をクリックしたらパーティクルを生成
func _on_Enemy_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_action_pressed("action_mouse"):
			var click_particles_node = load("res://scene/ClickParticles.tscn").instance()
#			click_particles_node.connect("tree_exited", self, "_on_ClickParticles_tree_exited") # NotUsed 
			
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
	power_button_label.text = "Money x" + str(unit_conversion(click_power_price))
	auto_power_button.text = "AutoPower +" + str(1) + "(" + str(Grobal.auto_click_power) + ")"
	auto_power_button_label.text = "Money x" + str(unit_conversion(auto_click_power_price))

# 3桁カンマ区切りの関数
func unit_conversion(_num):
	var digit:int = 0	# 桁数
	var thousands_separator = 0	# 3桁区切りの回数
	var num_conv = 0
	var num_conv_str
	
	# 数字が何桁(digit)あるか数える
	var _i = _num
	while _i > 0.99:
		_i /= 10
		digit += 1
	
	# 3桁カンマで何個あるかを調べる
	# 結果に -1 しているのは表示が小数点になってしまうため
	thousands_separator = round(digit / 3) - 1
	
	# 10単位以上は単位自体が存在しないため切り捨て
	# 単位は10種類["dummy", "K", "M", "G", "T", "P", "E", "Z", "Y", "R", "Q"]
	if thousands_separator > 10:
		# エラーが出ないように辞書の範囲内に収める
		thousands_separator = 10
	
	# 桁表示文字を加える(必要な場合)※10段階まで
	if thousands_separator > 0:
		# 回数分の切り捨てを行う
		num_conv = _num / (pow(1000, thousands_separator))
		
		# 計算結果に単位を追加
		num_conv_str = ("%5.4f" % num_conv) + Grobal.ThousandsSparatorUnit[thousands_separator]
		
		return num_conv_str
		
	else: # 数字が少なかったらそのまま表示
		return _num

# 終了時の処理
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		print("Quit")
		save_file()
	
func save_file():
	# セーブファイルの書き込みの準備
	var save_init = {
		"Money": str(Grobal.money),
		"Floor": str(Grobal.floor_num),
		"Farm_mode_flag": str(Grobal.farm_mode_flag),
		"Click_power": str(Grobal.click_power),
		"Auto_click_power": str(Grobal.auto_click_power)
	}
	
	# JSONテキストに変換
	var save_data = JSON.print(save_init, "\t")
	
	# セーブデータの書き込み処理
	var _save_file = File.new()
	_save_file.open(Grobal.SAVEFILE, File.WRITE)
	_save_file.store_string(save_data)
	_save_file.close()
	
func load_file():
	var _load_file = File.new()
	if _load_file.file_exists(Grobal.SAVEFILE):
		# セーブファイルが存在する場合
		_load_file.open(Grobal.SAVEFILE, File.READ)
		var load_conv = _load_file.get_as_text()
		# JSONテキストを変換
		var err = JSON.parse(load_conv)
		if err.error == OK:
			# 正常に変換できた場合
			# 読み込みの処理
			Grobal.money = err.result["Money"]
			Grobal.floor_num = err.result["Floor"]
#			print(str(err.result["Farm_mode_flag"]))
#			if err.result["Farm_mode_flag"] == 1:
#				farm_mode.pressed = true
			Grobal.click_power = err.result["Click_power"]
			Grobal.auto_click_power = err.result["Auto_click_power"]
			
		else:
			# 失敗したらセーブデータを作成
			pass
	else:
		# 存在しない場合はセーブデータを作成
		pass
