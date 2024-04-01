extends Label

onready var enemy_cooldown = $"../EnemyCooldown"

func _process(delta):
	text = str(Grobal.enemy_hp) + "/Timer= " + str(enemy_cooldown.wait_time)

