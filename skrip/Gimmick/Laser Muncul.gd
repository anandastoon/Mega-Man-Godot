extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var indeks = 0
var megaman
var boundary_laser = Vector2(0, 0)
# Properti lazahz
var jml = 0
var idx
var laserobj
onready var laser = preload("res://objek/Gimmick/Laser.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	idx = perpus.laser_data['mulaiLaser'][indeks]
	jml = perpus.laser_data['jumlahLaser'][indeks]
	
	for i in jml:
		laserobj = laser.instance()
		if (perpus.laser_data['pangkalLaser'][i + idx] == 99):
			match int(perpus.laser_data['dirLaser'][i + idx]):
				0:	laserobj.position.x = perpus.boundary_layar().x + perpus.lebar_asli_layar
				1:	laserobj.position.x = perpus.boundary_layar().x
				2:	laserobj.position.y = perpus.boundary_layar().y
				3:	laserobj.position.y = perpus.boundary_layar().y + perpus.lebar_asli_layar
		else:
			match int(perpus.laser_data['dirLaser'][i + idx]):
				0, 1:	laserobj.position.x = perpus.boundary_layar().x + perpus.laser_data['pangkalLaser'][i + idx] * perpus.LEBAR_BLOK
				2, 3:	laserobj.position.y = perpus.boundary_layar().y + perpus.laser_data['pangkalLaser'][i + idx] * perpus.LEBAR_BLOK
		
		match int(perpus.laser_data['dirLaser'][i + idx]):
			0, 3:	laserobj.arah = -1
			1, 2:	laserobj.arah = 1

		if (perpus.laser_data['kecLaser'][i + idx] != 99):
			laserobj.kecepatan = perpus.laser_data['kecLaser'][i + idx]

		if (perpus.laser_data['dirLaser'][i + idx] >= 2):
			laserobj.h_atau_v = "v"
			laserobj.position.x = perpus.boundary_layar().x + perpus.laser_data['yLaser'][i + idx] * 16 + 7
		else:
			laserobj.h_atau_v = "h"
			laserobj.position.y = perpus.boundary_layar().y + perpus.laser_data['yLaser'][i + idx] * 16 + 8
		laserobj.waktu = perpus.laser_data['waktuLaser'][i + idx]
		laserobj.stop = perpus.laser_data['stopLaser'][i + idx]
		laserobj.megaman = megaman
		get_parent().add_child(laserobj)
	queue_free()
	pass
