extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var direksi = Vector2(0, 0)
var sudut_dir = [0, 45, 90, 135, 180, 225, 270, 315]
var idks = 0
var kecepatan = 10

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func tampil(i):
	$AnimatedSprite.play("Mati")
	direksi = Vector2(cos(deg2rad(sudut_dir[i % 8])), sin(deg2rad(sudut_dir[i % 8])))
	idks = i
	pass

func _process(delta):
	kecepatan = 2 if idks < 8 else 4
	position += direksi * kecepatan
	pass
