extends Node2D

var countdown_pos = []
var leftwin_pos = []
var rightwin_pos = []
var p1pos = []
var p2pos = []
var p1score = 0
var p2score = 0
var start = false

# These will be given from playerselect.gd
var map
var player1
var player2
var player1obj
var player2obj

func countdown():
	var big3 = get_node('big3')
	var big2 = get_node('big2')
	var big1 = get_node('big1')
	var go = get_node('go')
	var p1indicator = get_node('p1indicator')
	var p2indicator = get_node('p2indicator')
	p1indicator.visible = true
	p2indicator.visible = true
	#note: change the below code to do pxindicator.position = (pxpos[0], pxpos[1]) for all the repeated lines
	p1indicator.position.x = p1pos[0]
	p1indicator.position.y = p1pos[1]
	p2indicator.position.x = p2pos[0]
	p2indicator.position.y = p2pos[1]
	big3.position.x = countdown_pos[0]
	big3.position.y = countdown_pos[1]
	big2.position.x = countdown_pos[0]
	big2.position.y = countdown_pos[1]
	big1.position.x = countdown_pos[0]
	big1.position.y = countdown_pos[1]
	go.position.x = countdown_pos[0]
	go.position.y = countdown_pos[1]
	var t = Timer.new()
	t.set_one_shot(true)
	self.add_child(t)
	t.set_wait_time(1)
	big3.visible = true
	t.start()
	yield(t, "timeout")
	big3.visible = false
	big2.visible = true
	t.start()
	yield(t, "timeout")
	big2.visible = false
	big1.visible = true
	t.start()
	yield(t, "timeout")
	big1.visible = false
	go.visible = true
	t.start()
	yield(t, "timeout")
	go.visible = false
	p1indicator.visible = false
	p2indicator.visible = false
	if p1score == 0 and p2score == 0:
		map.get_node("AudioStreamPlayer").play(0.0)
	start = true
	t.queue_free()

func spawn():
	start = false
	player1obj = load(player1).instance()
	player2obj = load(player2).instance()
	
	add_child(player1obj)
	add_child(player2obj)
	
	player1obj.changeControls(1, map.get_node("player1start").position)
	player2obj.changeControls(2, map.get_node("player2start").position)
	
	player1obj.connect("died", self, "handle_death2")
	player2obj.connect("died", self, "handle_death1")
	
	set_player_pos([map.get_node("player1start").position.x, map.get_node("player1start").position.y], [map.get_node("player2start").position.x, map.get_node("player2start").position.y])
	
	countdown()

# Called when the node enters the scene tree for the first time.
func _ready():
	var p1score_node = get_node('p1score')
	var p2score_node = get_node('p2score')
	var camera = get_node('Camera2D')
	
	var topLeft = camera.get_camera_screen_center() - camera.get_viewport_rect().size / 2 
	var topRight = camera.get_camera_screen_center() + camera.get_viewport_rect().size / 2 
	
	spawn()
	
	p1score_node.position = leftwin_pos
	p2score_node.position = rightwin_pos
	
func handle_death1():
	var explosionFX = load("res://VFX/explosion.tscn").instance()
	explosionFX.transform = player2obj.transform
	add_child(explosionFX)
	explosionFX.emitting = true
	
	player2obj.healthbar.queue_free()
	player2obj.queue_free()
	
	for node in get_children():
		if 'bullet' in node.name.to_lower():
			node.queue_free()
	var p1score_node = get_node('p1score')
	p1score += 1
	
	var t = Timer.new()
	t.set_one_shot(true)
	self.add_child(t)
	
	if p1score == 1:
		p1score_node.get_node("AnimationPlayer").play("onePoint")
		
		t.set_wait_time(3)
		t.start()
		yield(t, "timeout")
		
		player1obj.healthbar.queue_free()
		player1obj.queue_free()
		
		spawn()
	else:
		#theywin
		#thank you fireguy for that comment
		p1score_node.get_node("AnimationPlayer").play("twoPoint")
		
		t.set_wait_time(1)
		t.start()
		yield(t, "timeout")
		
		var search = player1obj.name
		var regex = RegEx.new()
		if not '@' in search:
			search = '@' + search + '@'
		regex.compile("@(.+)@")
		var result = regex.search(search)
		if result:
			var big_shape_name = result.get_strings()[1]
			var camera = get_node('Camera2D')
			var middle = camera.get_camera_screen_center()
			get_node('winAvatar').texture = load("res://Large Portraits/" + big_shape_name + "-big.png")
			get_node("winBackground").position = middle
			get_node("winAvatar").position = middle
			get_node("winForeground").position = middle
			get_node("winForeground").position.y += 200 * camera.zoom.y
			var scalex = camera.get_viewport().size.x / get_node("winBackground").texture.get_size().x
			var scaley = camera.get_viewport().size.y / get_node("winBackground").texture.get_size().y
			get_node("winBackground").scale = Vector2(scalex, scaley) * camera.zoom
			get_node("winBackground").visible = true
			get_node("winAvatar").scale = 5 * camera.zoom
			get_node("winAvatar").visible = true
			get_node("winForeground").scale = 15 * camera.zoom
			get_node("winForeground").visible = true
			get_node("winBanner").texture = load("res://assets/player1banner.png")
			get_node("winBanner").scale = Vector2(4, 2) * camera.zoom
			get_node("winBanner").visible = true
			get_node("winBanner").position = middle
			get_node("winBanner").position.y -= 350 * camera.zoom.y
			t.set_wait_time(5)
			t.start()
			yield(t, "timeout")
			var scene = load('res://scenes/menu.tscn').instance()
			get_parent().add_child(scene)
			queue_free()
				
func handle_death2():
	var explosionFX = load("res://VFX/explosion.tscn").instance()
	explosionFX.transform = player1obj.transform
	add_child(explosionFX)
	explosionFX.emitting = true
	
	player1obj.healthbar.queue_free()
	player1obj.queue_free()
	
	for node in get_children():
		if 'bullet' in node.name.to_lower():
			node.queue_free()
	var p2score_node = get_node('p2score')
	p2score += 1
	
	var t = Timer.new()
	t.set_one_shot(true)
	self.add_child(t)
	
	if p2score == 1:
		p2score_node.get_node("AnimationPlayer").play("onePoint")
		
		t.set_wait_time(3)
		t.start()
		yield(t, "timeout")
		
		player2obj.healthbar.queue_free()
		player2obj.queue_free()
		
		spawn()
	else:
		#theywin
		#thanks aryeh for that comment
		p2score_node.get_node("AnimationPlayer").play("twoPoint")
		
		t.set_wait_time(1)
		t.start()
		yield(t, "timeout")
		
		var search = player2obj.name
		var regex = RegEx.new()
		if not '@' in search:
			search = '@' + search + '@'
		regex.compile("@(.+)@")
		var result = regex.search(search)
		if result:
			var big_shape_name = result.get_strings()[1]
			var camera = get_node('Camera2D')
			var middle = camera.get_camera_screen_center()
			get_node('winAvatar').texture = load("res://Large Portraits/" + big_shape_name + "-big.png")
			get_node("winBackground").position = middle
			get_node("winAvatar").position = middle
			get_node("winForeground").position = middle
			get_node("winForeground").position.y += 200 * camera.zoom.y
			var scalex = camera.get_viewport().size.x / get_node("winBackground").texture.get_size().x
			var scaley = camera.get_viewport().size.y / get_node("winBackground").texture.get_size().y
			get_node("winBackground").scale = Vector2(scalex, scaley) * camera.zoom
			get_node("winBackground").visible = true
			get_node("winAvatar").scale = 5 * camera.zoom
			get_node("winAvatar").visible = true
			get_node("winForeground").scale = 15 * camera.zoom
			get_node("winForeground").visible = true
			get_node("winBanner").texture = load("res://assets/player2banner.png")
			get_node("winBanner").scale = Vector2(4, 2) * camera.zoom
			get_node("winBanner").visible = true
			get_node("winBanner").position = middle
			get_node("winBanner").position.y -= 350 * camera.zoom.y
			t.set_wait_time(5)
			t.start()
			yield(t, "timeout")
			var scene = load('res://scenes/menu.tscn').instance()
			get_parent().add_child(scene)
			queue_free()

func set_countdown_pos(pos):
	countdown_pos = pos

func set_player_pos(pos1, pos2):
	p1pos = pos1
	p2pos = pos2
	player1obj.position = Vector2(pos1[0], pos1[1])
	player2obj.position = Vector2(pos2[0], pos2[1])

func set_wincount_pos(leftwin, rightwin):
	leftwin_pos = leftwin
	rightwin_pos = rightwin

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
