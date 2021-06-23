extends Node2D

var p1cursor = [0, 0]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
onready var worlds = [[$Gravity, $'Second Chance', $Moat]]
onready var selector = $Selector
var map = ''

func _process(_delta):
	if Input.is_action_just_pressed('right1'):
		if p1cursor[0] == len(worlds[p1cursor[1]])-1:
			p1cursor[0] = 0
		else:
			p1cursor[0] += 1

	if Input.is_action_just_pressed('left1'):
		if p1cursor[0] == 0:
			p1cursor[0] = len(worlds[p1cursor[1]])-1
		else:
			p1cursor[0] -= 1
	
	if Input.is_action_just_pressed('down1'):
		if p1cursor[1] == len(worlds)-1:
			p1cursor[1] = 0
		elif len(worlds[p1cursor[1]+1]) >= p1cursor[0]+1:
			p1cursor[1] += 1
		else:
			p1cursor[1] = 0
	
	if Input.is_action_just_pressed('up1'):
		if p1cursor[1] == 0:
			if len(worlds[-1]) >= p1cursor[0]+1:
				p1cursor[1] = len(worlds)-1
			else:
				p1cursor[1] = len(worlds)-2
		else:
			p1cursor[1] -= 1
	
	selector.position.x = p1cursor[0]*100
	selector.position.y = p1cursor[1]*100
	
	if Input.is_action_just_pressed('shoot1'):
		$Camera2D.current = false
		var scene = load('res://scenes/playerselect.tscn').instance()
		map = worlds[p1cursor[1]][p1cursor[0]].name
		for node in scene.get_children():
			if node.get_class() == 'Node':
				node.name = map

		scene.global_position = global_position
		get_parent().add_child(scene)
		queue_free()
