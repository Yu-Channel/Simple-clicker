extends Particles2D

onready var particles_timer = $ParticlesTimer

func _ready():
	particles_timer.wait_time = lifetime
	particles_timer.pause_mode = 0
	emitting = true

func _process(_delta):
	if particles_timer.wait_time <= 0:
		queue_free()
