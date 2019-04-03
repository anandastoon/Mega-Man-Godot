extends KinematicBody2D

export var arah = "atas"
export var kecepatan = 1
export var waktu_ganti = 60
var waktu = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if (waktu >= waktu_ganti):
		waktu = 0
		kecepatan = -kecepatan
	else:
		waktu += 1
		
	if (arah == "atas" || arah == "bawah"):
		position.y += kecepatan
	else:
		position.x += kecepatan
		
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
