extends Area2D

var kecH = 0
var kecV = 0
var kecepatan = Vector2(0, 0)
var kecH_temp = 0
var kecV_temp = 0
var kecH_strik = 0.2
var kecV_strik = 0.08
var arahH = 0
var arahV = 0
var tipe_serang = 0

func _ready():
	if (arahH > 0): $Sprite.set_flip_h(true)
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if (tipe_serang == 0):
		if (kecH >= kecH_temp):
			kecH_temp += kecH_strik
			position.x += kecH_temp * arahH
	
		if (kecV > 0):
			kecV -= kecV_strik
			position.y -= kecV * arahV
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass


func _on_Bullet_Kecil_area_exited( area ):
	if (area.name == perpus.nama_kamera):
		queue_free()
	pass # replace with function body


func _on_Bullet_Kecil_body_entered( body ):
	if (body.name == perpus.nama_megaman):
		body.kena(2)
		queue_free()
	pass # replace with function body
