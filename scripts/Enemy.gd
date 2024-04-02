extends Area2D


func _ready():
	# もし階層が0以下なら1に修正
	if Grobal.floor_num < 1:
		Grobal.floor_num = 1
	
	# 最初の敵を配置する
	set_enemy_hp()

func _process(delta):
	enemy_slayed()
	# 時間制限
	if !(Grobal.floor_num % 10):
		Grobal.time_limit -= delta
		if Grobal.time_limit <= 0:
			loot_money()
			queue_free()

# クリックしたときの処理
func _on_Enemy_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			Grobal.enemy_hp -= Grobal.click_power
			
			# 敵を倒したときの処理
			enemy_slayed()

func enemy_slayed():
	if Grobal.enemy_hp <= 0:
		Grobal.enemy_hp = 0
		loot_money()
		queue_free()

# 敵のHPを階層によって変化させる
func set_enemy_hp():
	var enemy_hp:float = 0
	enemy_hp = int(10 * (1 + pow(Grobal.floor_num, 1.18) - 1) * 0.2)
	
	# 10の倍数floorごとに
	if !(Grobal.floor_num % 10):
		enemy_hp *= 1 + (pow(Grobal.floor_num / 10, 2) * 0.1)
		Grobal.time_limit = Grobal.LIMIT_TIMER_NUM
	
	# 最大HPを代入 (intで少数点以下を切る)
	Grobal.enemy_max_hp = int(enemy_hp)
	# 現在HPに最大HPと同じ値を代入
	Grobal.enemy_hp = Grobal.enemy_max_hp

# 敵を倒した時に得られるお金
func loot_money():
	var money:float = 0
	money = 10 * (1 + pow(Grobal.floor_num, 1.12) * 0.2)
	Grobal.money += int(money)

