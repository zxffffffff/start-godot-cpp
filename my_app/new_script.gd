extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	# C++ modules
	var s = Summator.new()
	s.add(100)
	s.add(20)
	s.add(3)
	# print("[cpp_modules] Summator ", s.get_total())
	$TextEdit.text = "[cpp_modules] Summator %d" % s.get_total()
	s.reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_gd_example_position_changed(node, new_pos):
	$GDExample/Label.text = "[cpp_extensions] {0} position_changed {1}".format([node.get_class(), str(new_pos)])
