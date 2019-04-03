extends StaticBody2D

export var indeks_bias = "atas"
export var indeks_stop = 0
var waktu_kedip = 5
var aksi_hanya_sekali = true

onready var laser = preload("res://objek/Gimmick/Laser.tscn")

func _ready():
	match indeks_bias:
		"atas": $Sprite.frame = 1
		"kanan": $Sprite.frame = 4
		"bawah": $Sprite.frame = 3
		"kiri": $Sprite.frame = 2
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func aksi():
	if (aksi_hanya_sekali):
		aksi_hanya_sekali = false
		$Sprite2.show()
		yield(get_tree().create_timer(0.07), "timeout")
		$Sprite2.hide()
		var laserobj = laser.instance()
		laserobj.position = position
#		laserobj.position.x = int(position.x) % perpus.lebar_asli_layar
#		laserobj.position.y = int(position.y) % perpus.lebar_asli_layar
		if (indeks_bias == "atas" || indeks_bias == "bawah"):
			laserobj.h_atau_v = "v"
		else:
			laserobj.h_atau_v = "h"
			
		if (indeks_bias == "atas" || indeks_bias == "kiri"):
			laserobj.arah = -1
		else:
			laserobj.arah = 1
			
		laserobj.waktu = 1
		laserobj.stop = indeks_stop
		laserobj.biased = true
		laserobj.megaman = get_parent().get_node("Megaman")
		get_parent().get_node("StakMusuh").add_child(laserobj)
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Area2D_area_entered( area ):
	if (area.name == "AreaKamera"):
		aksi_hanya_sekali = true
	pass # replace with function body
