extends Node2D

func get_pushed(dir):
	var try = get_parent().request_move(self, dir)
	if try[1]:
		if try[1] is preload("res://Table.gd"):
			get_parent().food_eaten()
			self.position=Vector2(-1, -1)
			try[1].position=self.position
			try[1].queue_free()
			self.queue_free()
	else:
		position=try[0]
	

func _ready():
	pass
