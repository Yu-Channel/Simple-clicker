extends Particles2D

onready var explode_timer = $ExplodeTimer

var _timer = lifetime

func _ready():
	# 同一シーン内のもの全てのプロパティ値を変更されないためのバグ回避策
	process_material = process_material.duplicate()
	
	explode_timer.wait_time = lifetime
	explode_timer.process_mode = 0
	explode_timer.one_shot = 1
	emitting = true
	explode_timer.start()

func _physics_process(_delta):
	if _timer < 0.6 and !(_timer <= 0):
		if process_material.color.a > 0:
			process_material.color.a -= _delta * 2
		else:
			process_material.color.a = 0
	_timer -= _delta

func _on_ExplodeTimer_timeout():
	queue_free()
