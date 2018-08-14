extends "res://actor.gd"
export (PackedScene) var body;

const name_to_v={'right':Vector2(1, 0), 'left':Vector2(-1, 0),
		 'up':Vector2(0, -1), 'down':Vector2(0, 1)}

var queue = [] # slow

#current direction
var cdir=name_to_v['right']
#wanted direction
var wdir=cdir

var extra_segments=0

func take_turn():
	if wdir==-cdir:
		wdir=cdir
		
	match get_parent().request_move($head, wdir):
		[var pos, var act]: #python-like unpacking
			if act:
				get_node('../../TurnTimer').stop()
				get_node('../../LoseGame').show()
				return
		
			var newbod=body.instance()
			add_child(newbod)
			queue.push_front([newbod, wdir.angle()]) #angle so the tail can follow
			newbod.get_node('AnimatedSprite').play('middle' if wdir==cdir else 'rotation')
			var ang = wdir.angle() if sin(wdir.angle()-cdir.angle())>=0 else wdir.angle()-PI/2
			newbod.get_node('AnimatedSprite').rotation = ang
			newbod.position=$head.position
			$head.position=pos
	$head/AnimatedSprite.rotation = wdir.angle()
	
	if extra_segments == 0:
		$tail.rotation=queue[-1][1]
		$tail.position=queue[-1][0].position
		queue[-1][0].queue_free()
		queue.pop_back()
	else:
		extra_segments -= 1
	cdir=wdir

func grow():
	extra_segments+=1

func _ready():
	$tail/AnimatedSprite.play('tail')

func _process(delta):
	for k in name_to_v:
		if Input.is_action_pressed('ui_'+k):
			wdir=name_to_v[k]
