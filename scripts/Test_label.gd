extends Label

onready var main_node = $".."

func _process(_delta):
	text = ("\nfloor:" + str(Grobal.floor_num)
		+ "\nmoney:" + str(Grobal.money)
		+ "\npowermoney:" + str(main_node.click_power_price)
		+ "\nloop flag:" + str(Grobal.farm_mode_flag)
	)

