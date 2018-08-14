extends Node2D

func _ready():
	pass
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_TurnTimer_timeout():
	if rage>0:
		rage-=1
	$Rage.value=rage
	$TileMap/Snake.take_turn()
	
var points=0
var rage=50

func food_eaten():
	points+=rage
	rage+=30
	rage=min(rage, 50)
	$Points.text=str(points)

func _on_GoButton_pressed():
	seed($SeedEdit.text.hash())
	$SeedEdit.hide()
	$GoButton.hide()
	$TurnTimer.start()
