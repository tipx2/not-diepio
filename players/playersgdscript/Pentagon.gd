extends KinematicBody2D

var Bullet = preload('res://bullets/PentagonBullet.tscn')
var HealthBar = preload('res://uielements/Healthbar.tscn')

var healthbar = HealthBar.instance()

var controls = ['up1', 'down1', 'left1', 'right1', 'shoot1']

func _ready():
	visible = false

const speed = 100
const rotation_speed = 3
var motion = Vector2()
var rotation_dir = 0
var just_shot = 50
var health = 50
var change_health = true

func get_input():
	rotation_dir = 0
	motion = Vector2.ZERO
	if Input.is_action_pressed(controls[3]):
		rotation_dir += 1
	if Input.is_action_pressed(controls[2]):
		rotation_dir -= 1
	if Input.is_action_pressed(controls[1]):
		motion = Vector2(-speed, 0).rotated(rotation)
	if Input.is_action_pressed(controls[0]):
		motion = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	if get_parent().start:
		if health <= 0:
			healthbar.queue_free()
			queue_free()
		get_input()
		rotation += rotation_dir * rotation_speed * delta
		motion = move_and_slide(motion)


		if Input.is_action_just_pressed(controls[4]):
			visible = true
			if just_shot >= 50:
				just_shot = 0
				$AnimationPlayer.play('Shooting')
				var t = Timer.new()
				t.set_wait_time(0.2)
				t.set_one_shot(true)
				self.add_child(t)
				t.start()
				yield(t, "timeout")
				t.queue_free()
				shoot()
			$AnimationPlayer.play("Vanishing")
			yield(get_node("AnimationPlayer"), "animation_finished")
			visible = false

		just_shot += 1
		move_and_slide(motion)

func _process(_delta):
	if get_parent().start:
		if visible == false:
			healthbar.visible = false
		elif visible == true:
			healthbar.visible = true
		if change_health:
			get_parent().add_child(healthbar)
			change_health = false
		
		healthbar.healthNeg(health)
		
		healthbar.global_position.x = position.x
		healthbar.global_position.y = position.y - 50
	
func shoot():
	var b = Bullet.instance()
	b.shot_from = self.get_instance_id()
	get_parent().add_child(b)
	b.transform = $muzzle.global_transform

func changeControls(player, map_position):
	if player == 2:
		controls = ['up2', 'down2', 'left2', 'right2', 'shoot2']
	elif player == 1:
		controls = ['up1', 'down1', 'left1', 'right1', 'shoot1']
	position = map_position
