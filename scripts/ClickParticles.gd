extends Particles2D

onready var particles_timer = $ParticlesTimer

func _ready():
	particles_timer.wait_time = lifetime
	particles_timer.process_mode = 0
	particles_timer.one_shot = 1
	emitting = true
	particles_timer.start()

# timerが timeout したら自身を削除
func _on_ParticlesTimer_timeout():
	queue_free()

