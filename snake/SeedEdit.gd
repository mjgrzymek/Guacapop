extends LineEdit

func _ready():
	randomize()
	self.text='seed: '+str(randi()%1000000000000)
	