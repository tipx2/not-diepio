extends Node2D

var p1cursor = [0, 0]
var p2cursor = [0, 1]
var player1chosen = false
var player2chosen = false
var player1choice = false
var player2choice = false
var player1name = ''
var player2name = ''
onready var p1con = $player1select
onready var p2con = $player2select

onready var players = [[$Triangle, $Circle, $Hexagon, $Pentagon, $Square], [$Sprite4, $Sprite5]]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed('right1'):
		if p1cursor[0] == len(players[p1cursor[1]])-1:
			p1cursor[0] = 0
		else:
			p1cursor[0] += 1

	if Input.is_action_just_pressed('left1'):
		if p1cursor[0] == 0:
			p1cursor[0] = len(players[p1cursor[1]])-1
		else:
			p1cursor[0] -= 1
	
	if Input.is_action_just_pressed('down1'):
		if p1cursor[1] == len(players)-1:
			p1cursor[1] = 0
		elif len(players[p1cursor[1]+1]) >= p1cursor[0]+1:
			p1cursor[1] += 1
		else:
			p1cursor[1] = 0
	
	if Input.is_action_just_pressed('up1'):
		if p1cursor[1] == 0:
			if len(players[-1]) >= p1cursor[0]+1:
				p1cursor[1] = len(players)-1
			else:
				p1cursor[1] = len(players)-2
		else:
			p1cursor[1] -= 1
	
	if Input.is_action_just_pressed('right2'):
		if p2cursor[0] == len(players[p2cursor[1]])-1:
			p2cursor[0] = 0
		else:
			p2cursor[0] += 1

	if Input.is_action_just_pressed('left2'):
		if p2cursor[0] == 0:
			p2cursor[0] = len(players[p2cursor[1]])-1
		else:
			p2cursor[0] -= 1
	
	if Input.is_action_just_pressed('down2'):
		if p2cursor[1] == len(players)-1:
			p2cursor[1] = 0
		elif len(players[p2cursor[1]+1]) >= p2cursor[0]+1:
			p2cursor[1] += 1
		else:
			p2cursor[1] = 0
	
	if Input.is_action_just_pressed('up2'):
		if p2cursor[1] == 0:
			if len(players[-1]) >= p2cursor[0]+1:
				p2cursor[1] = len(players)-1
			else:
				p2cursor[1] = len(players)-2
		else:
			p2cursor[1] -= 1
	
	$p1selector.position.x = p1cursor[0]*100
	$p1selector.position.y = p1cursor[1]*100
	
	$p2selector.position.x = p2cursor[0]*100
	$p2selector.position.y = p2cursor[1]*100
	
	if Input.is_action_just_pressed('shoot1'):
		p1con.text = "Player 1 has confirmed!"
		if "Sprite" in players[p1cursor[1]][p1cursor[0]].name:
			$p1big.texture = load("res://Large Portraits/icon-big.png")
			p1con.text = "Pick someone else"
			player1chosen = false
		else:
			player1name = 'res://players/' + players[p1cursor[1]][p1cursor[0]].name + '.tscn'
			player1chosen = true
			$p1big.texture = load("res://Large Portraits/" + players[p1cursor[1]][p1cursor[0]].name + "-big.png")
		$WordFlasher.play("flash1")
		$PicFlasher.play("picflash1")
	
	if Input.is_action_just_pressed('shoot2'):
		p2con.text = "Player 2 has confirmed!"
		if "Sprite" in players[p2cursor[1]][p2cursor[0]].name:
			$p2big.texture = load("res://Large Portraits/icon-big.png")
			p2con.text = "Pick someone else"
			player2chosen = false
		else:
			player2name = 'res://players/' + players[p2cursor[1]][p2cursor[0]].name + '.tscn'
			player2chosen = true
			$p2big.texture = load("res://Large Portraits/" + players[p2cursor[1]][p2cursor[0]].name + "-big.png")
		$WordFlasher.play("flash2")
		$PicFlasher.play("picflash2")
	
func checkChangeScene():
	if player1chosen and player2chosen:
		$Camera2D.current = false
		var map = ''
		for node in get_children():
			if node.get_class() == 'Node':
				map = 'res://maps/' + node.name + '.tscn'
		var camera = load('res://uielements/goodcamera.tscn').instance()
		var scene = load('res://scenes/emptyworld.tscn').instance()
		if map == "res://maps/Second Chance.tscn":
			camera.zoom = Vector2(1.5,1.5)
		map = load(map).instance()
		scene.map = map
		scene.player1 = player1name
		scene.player2 = player2name
		scene.set_countdown_pos([map.get_node('countdownpos').position.x, map.get_node('countdownpos').position.y])
		scene.set_wincount_pos(map.get_node('leftwincount').position, map.get_node('rightwincount').position)
		scene.add_child(camera)
		scene.add_child(map)
		scene.global_position = global_position
		get_parent().add_child(scene)
		queue_free()


func _on_Button_pressed():
	$Camera2D.current = false
	var scene = load('res://scenes/worldselect.tscn').instance()
	scene.global_position = global_position
	get_parent().add_child(scene)
	queue_free()


func _on_Button2_pressed():
	checkChangeScene()
