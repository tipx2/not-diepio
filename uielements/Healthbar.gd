extends Area2D
onready var healthpos = $HealthBarGreen.position.x
func healthNeg(health):
	$HealthBarGreen.region_rect = Rect2(0,0,health,5)
	$HealthBarGreen.position.x = healthpos - (50 - health)/2
