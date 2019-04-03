extends KinematicBody2D

var kecH = 0
var kecV = 0
var kecepatan = Vector2(0, 0)
var kecH_temp = 0
var kecV_temp = 0
var arah = 1
var arahH = 0
var arahV = 0
var tipe_serang = 0
var megaman

onready var bullet_ledak = preload("res://objek/Napalm Man/Bullet Ledak.tscn")

func _ready():
	if (arah > 0): $Sprite.set_flip_h(true)
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	kecepatan.y += perpus.GRAVITASI * delta
	if (is_on_wall()):
		arah = -arah
		$Sprite.set_flip_h(true)
	if (is_on_floor()): selesai ()
	kecepatan.x = arahH * arah
	move_and_slide(kecepatan, Vector2(0,-1))
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass


func _on_Bullet_Kecil_area_exited( area ):
	if (area.name == perpus.nama_kamera):
		queue_free()
	pass # replace with function body


func _on_Bullet_Kecil_body_entered( body ):
	if (body.name == perpus.nama_megaman):
		selesai ()
		body.kena(2)
	pass # replace with function body
	
func selesai ():
	var bullet_ledakM = bullet_ledak.instance()
	bullet_ledakM.position = global_position
	bullet_ledakM.tipe_serang = 0
	get_parent().add_child(bullet_ledakM)
	queue_free()
