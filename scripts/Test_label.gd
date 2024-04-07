extends Label

onready var enemy_cooldown = $"../EnemyCooldown"

func _process(_delta):
	text = ("\nfloor:" + str(Grobal.floor_num)
		+ "\ntimer:" + str(Grobal.time_limit)
		+ "\nmoney:" + str(Grobal.money))

