extends Label

onready var enemy_cooldown = $"../EnemyCooldown"

func _process(delta):
	text = "HP:" + str(Grobal.enemy_hp) + " floor:" + str(Grobal.floor_num)

