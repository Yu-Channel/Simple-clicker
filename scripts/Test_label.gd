extends Label

onready var enemy_cooldown = $"../EnemyCooldown"

func _process(delta):
	text = "HP:" + str(Grobal.enemy_hp) + "\nfloor:" + str(Grobal.floor_num) + "\ntimer:" + str(Grobal.time_limit)

