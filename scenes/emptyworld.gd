extends Node2D

var start = false
var countdown_pos = []
var p1pos = []
var p2pos = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var big3 = get_node('big3')
	var big2 = get_node('big2')
	var big1 = get_node('big1')
	var go = get_node('go')
	var p1indicator = get_node('p1indicator')
	var p2indicator = get_node('p2indicator')
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
	big3.queue_free()
	big2.visible = true
	t.start()
	yield(t, "timeout")
	big2.queue_free()
	big1.visible = true
	t.start()
	yield(t, "timeout")
	big1.queue_free()
	go.visible = true
	t.start()
	yield(t, "timeout")
	go.queue_free()
	p1indicator.visible = false
	p2indicator.visible = false
	start = true

func set_countdown_pos(pos):
	countdown_pos = pos

func set_player_pos(pos1, pos2):
	p1pos = pos1
	p2pos = pos2

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
