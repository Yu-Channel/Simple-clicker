extends Area2D


func _ready():
	if Grobal.floor_num < 1:
		Grobal.floor_num = 1
	
	set_enemy_hp()

func _process(delta):
	if !(Grobal.floor_num % 10):
		Grobal.time_limit -= delta
		if Grobal.time_limit <= 0:
			loot_money()
			queue_free()

func _on_Enemy_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			Grobal.enemy_hp -= 1
			
			# 敵を倒したときの処理
			if Grobal.enemy_hp <= 0:
				loot_money()
				queue_free()

# 敵のHPを階層によって変化させる
func set_enemy_hp():
	var enemy_hp:float = 0
	enemy_hp = int(10 * (1 + Grobal.floor_num * 0.2))
	
	# 10の倍数ごとにボス
	if !(Grobal.floor_num % 10):
		enemy_hp *= 1 + (pow(Grobal.floor_num / 10, 2) * 0.1)
		Grobal.time_limit = Grobal.LIMIT_TIMER_NUM
	
	Grobal.enemy_max_hp = int(enemy_hp)	
	# 現在HPに最大HPと同じ値を代入
	Grobal.enemy_hp = Grobal.enemy_max_hp

# 敵を倒した時に得られるお金
func loot_money():
	var money:float = 0
	money = 10 * (1 + pow(Grobal.floor_num, 2) * 0.2)
	Grobal.money += int(money)

