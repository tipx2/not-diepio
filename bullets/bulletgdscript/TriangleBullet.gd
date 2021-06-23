extends Area2D

var speed = 750
var shot_from = ''

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_TriangleBullet_body_entered(body):
	if body.get('health') and body.get_instance_id() != shot_from:
		body.health -= 4
	if body.get_instance_id() != shot_from:
		queue_free()
