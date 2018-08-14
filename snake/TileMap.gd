extends TileMap
export(PackedScene) var food
export(PackedScene) var table

onready var maxrect = [1024, 640]

func get_cell_pawn(coordinates): # slow
	for what in [get_children(), $Snake.get_children()]:
		for node in what:
			if world_to_map(node.position) == coordinates:
				return(node)
			
func request_move(pawn, direction):
	var cell_start = world_to_map(pawn.position)
	var cell_target = cell_start + direction
	
	for i in [0, 1]:
		if map_to_world(cell_target)[i]>=maxrect[i]:
			cell_target[i]=0
		if map_to_world(cell_target)[i]<0:
			var new=Vector2()
			new[1-i]=cell_target[1-i]*cell_size[1-i]
			new[i]=maxrect[i]-1
			cell_target=world_to_map(new)
			
	var curr_actor = get_cell_pawn(cell_target)
		
	if curr_actor:
		curr_actor.get_pushed(direction)
		
	return [map_to_world(cell_target)+cell_size/2, get_cell_pawn(cell_target)]

func rand_free_pos():
	var new_pos = Vector2(randi()%maxrect[0], randi()%maxrect[1])
	while get_cell_pawn(world_to_map(new_pos)) or (new_pos-$Snake.position).length()<=cell_size[0]:
		new_pos = Vector2(randi()%maxrect[0], randi()%maxrect[1])
	return map_to_world(world_to_map(new_pos))+cell_size/2



func spawn_items():
	
	var new_food = food.instance()
	new_food.position=rand_free_pos()
	add_child(new_food)
	
	new_food = table.instance()
	new_food.position=rand_free_pos()
	add_child(new_food)

func food_eaten():
	$Snake.grow()
	get_parent().food_eaten()
	spawn_items()
	if randi()%3 == 0:
		spawn_items()
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

var started=false
func _on_TurnTimer_timeout():
	if not started:
		started = true
		spawn_items()
