extends Area2D

var speed = 750
var shot_from = ''

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Area2D_body_entered(body):
	if body.get('health') and body.get_instance_id() != shot_from:
		queue_free()
		body.health -= 4
		if "Pentagon" in body.name:
			body.disappear()
	elif body.get_instance_id() != shot_from:
		queue_free()
