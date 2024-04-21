extends Area2D

# ==============================================================================
# Section: ファイルの読み込み準備 ===================================================
var enemy_sprite_texture = load("res://sprite/monster01.png")

# ==============================================================================
# Section: ノードの読み込み準備 =====================================================
onready var enemy_sprite = $Sprite

# ==============================================================================
# Section: 変数の宣言 ============================================================
var enemy_shake_time:float = 0

# ==============================================================================
# Section: ノードの準備 ===========================================================
func _ready():
	# もし階層が0以下なら1に修正
	if Grobal.floor_num < 1:
		Grobal.floor_num = 1
	
	# 最初の敵を配置する
	set_enemy_hp()

# ==============================================================================
# Section: 1フレームごとの処理(1/60fps) ============================================
func _process(_delta):
	
	enemy_slayed()
	
	# 時間制限 -------------------------------------------------------------------
	if !(Grobal.floor_num % 10):
		Grobal.time_limit -= _delta
		if Grobal.time_limit <= 0:
			loot_money()
			queue_free()
	
	# クリックしたときの振動 および 効果時間減少 ----------------------------------------
	if enemy_shake_time > 0:
		enemy_shake_time -= 1
		enemy_sprite.position.x = 0.5 * rand_range(-1, 1) * enemy_shake_time
		enemy_sprite.position.y = 0.5 * rand_range(-1, 1) * enemy_shake_time

# ==============================================================================
# Section: シグナル関連の処理 ======================================================
# 敵をクリックしたときの処理 ---------------------------------------------------------
func _on_Enemy_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.is_action_pressed("action_mouse"):
			Grobal.enemy_hp -= Grobal.click_power
			
			enemy_shake_time = 30
			
			# 敵を倒したときの処理
			enemy_slayed()

# 敵を倒したときの処理 ==============================================================
func enemy_slayed():
	if Grobal.enemy_hp <= 0:
		Grobal.enemy_hp = 0
		loot_money()
		queue_free()

# 敵のHPを階層によって変化させる ======================================================
func set_enemy_hp():
	var enemy_hp:float = 0
	enemy_hp = int(10 * (1 + pow(Grobal.floor_num, 1.18) - 1) * 0.2)
	
	enemy_sprite.texture = enemy_sprite_texture
	
	# 10の倍数floorごとにボス用のHPを設定
	if !(Grobal.floor_num % 10):
		enemy_hp *= 1 + (pow(float(Grobal.floor_num) / 10, 2) * 0.1)
		Grobal.time_limit = Grobal.LIMIT_TIMER_NUM
	else: # 雑魚用のHPを設定
		enemy_hp *= 1 + (pow(float(Grobal.floor_num) / 10, 2) * 0.0013)
	
	# 最大HPを代入 (intで少数点以下を切る)
	Grobal.enemy_max_hp = int(enemy_hp)
	# 現在HPに最大HPと同じ値を代入
	Grobal.enemy_hp = Grobal.enemy_max_hp

# 敵を倒した時に得られるお金 =========================================================
func loot_money():
	var money:float = 0
	# 設定の調整の必要性あり。v1.2=1.28
	money = 10 * (1 + pow(Grobal.floor_num, 1.62) * 0.2 * Grobal.floor_num)
	Grobal.money += int(money)
	
