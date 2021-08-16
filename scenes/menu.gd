extends CanvasLayer

onready var tween = $Tween

func appear():
	tween.interpolate_property(self, "offset:x", 500, 0, 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

func disappear():
	tween.interpolate_property(self, "offset:x", 0, 500, 0.4, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()

func _ready():
	appear()


func _on_Quit_pressed():
	get_tree().quit()


func _on_Play_pressed():
	disappear()
	var t = Timer.new()
	t.set_wait_time(0.3)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	get_tree().change_scene("res://scenes/worldselect.tscn")
