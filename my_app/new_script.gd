extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	# C++ modules
	var s = Summator.new()
	s.add(10)
	s.add(20)
	s.add(30)
	print(s.get_total())
	s.reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
