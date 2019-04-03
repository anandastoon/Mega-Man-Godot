extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var mode = "Kanan"
var kecepatan_konveyor = 1
var megaman

func _ready():
	megaman = get_node("/root/Level/Megaman")
	print(megaman)
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if (overlaps_body(megaman)):
		if (mode == "Kanan"):
			megaman.position.x += kecepatan_konveyor
		else:
			megaman.position.x -= kecepatan_konveyor
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass


func _on_Konveyor_Coll_body_entered( body ):
	pass # replace with function body
