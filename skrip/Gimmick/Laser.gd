extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (Texture) var laserTeksturH
export (Texture) var laserTeksturV

var arah = -1
var h_atau_v = "h"
var berhenti = false
var biased = false

#Setelah transisi beresin semua laser
var setelah_transisi = false

var megaman

var posisi_awal = 0 # Untuk keperluan hitbox pangkal laser

var kecepatan = 4
var waktu = 0
var stop = 0

onready var level = get_parent().get_parent()
onready var stak_laser = level.stak_laser
onready var kamera = level.get_node("Camera2D")

func _ready():
	if (h_atau_v == "h"):
		$"Laser Objek/CollisionShape2D".disabled = false
		$"Laser Objek/CollisionShape2D2".disabled = true
	else:
		$"Laser Objek/CollisionShape2D2".disabled = false
		$"Laser Objek/CollisionShape2D".disabled = true
		
	$"Laser Objek".hide()
	posisi_awal = position.x if h_atau_v == "h" else position.y
	$"Laser Objek".get_node("AnimationPlayer").play("Kepala Laser")
	#$"Laser Objek".get_node("Sprite").texture = laserTeksturH if h_atau_v == "h" else laserTeksturV
	pass

func _process(delta):
	if (!perpus.transisi):
		
		if (!berhenti && waktu < 0):
			if (h_atau_v == "h"): $"Laser Objek".position.x += kecepatan * arah
			else: $"Laser Objek".position.y += kecepatan * arah
			
		if (setelah_transisi):
			queue_free()
			for i in stak_laser.get_children():
				i.queue_free()
		
		if (waktu <= 0):
			if (h_atau_v == "h"):
				if (megaman.position.y - 18 < position.y && megaman.position.y + 16 > position.y):
					if ( (arah < 0 && megaman.position.x + 12 > $"Laser Objek".global_position.x && megaman.position.x - 4 < posisi_awal) ||
						(arah > 0 && megaman.position.x - 12 < $"Laser Objek".global_position.x && megaman.position.x + 4 > posisi_awal) ):
						megaman.kena(28)
			else:
				if (megaman.position.x - 12 < position.x && megaman.position.x + 12 > position.x):
					if ( (arah < 0 && megaman.position.y + 16 > $"Laser Objek".global_position.y && megaman.position.y - 4 < posisi_awal) ||
						(arah > 0 && megaman.position.y - 16 < $"Laser Objek".global_position.y && megaman.position.y + 4 > posisi_awal) ):
						megaman.kena(28)
	
		if (!berhenti):
			if (h_atau_v == "h"):
				if ( (arah == -1 && $"Laser Objek".global_position.x <= kamera.position.x - perpus.setengah_layar + stop * 16 + 2) ||
					(arah == 1 && $"Laser Objek".global_position.x >= kamera.position.x - perpus.setengah_layar + stop * 16 - 2) ):
					if (!berhenti):
						$"Laser Objek".hide()
						var gambar_laser = Sprite.new()
						gambar_laser.texture = laserTeksturH
						gambar_laser.position = $"Laser Objek".global_position
						gambar_laser.position.x = $"Laser Objek".global_position.x - 4 * arah
						stak_laser.add_child(gambar_laser)
						berhenti = true	
				else:
					if (waktu < 0):
						var gambar_laser = Sprite.new()
						gambar_laser.texture = laserTeksturH
						gambar_laser.position = $"Laser Objek".global_position
						gambar_laser.position.x = $"Laser Objek".global_position.x + 0 * arah
						stak_laser.add_child(gambar_laser)
					else:
						waktu -= 1
						if (waktu == 0):
							$"Laser Objek".show()
							perpus.mainkan_sfx("laser")
							var gambar_laser = Sprite.new()
							gambar_laser.texture = laserTeksturH
							gambar_laser.position = $"Laser Objek".global_position
							gambar_laser.position.x = $"Laser Objek".global_position.x + 4 * arah
							stak_laser.add_child(gambar_laser)
			else:
				if ( (arah == -1 && $"Laser Objek".global_position.y <= kamera.position.y - perpus.setengah_layar + stop * 16 + 2) ||
					(arah == 1 && $"Laser Objek".global_position.y >= kamera.position.y - perpus.setengah_layar + stop * 16 - 2) ):
					if (!berhenti):
						$"Laser Objek".hide()
						berhenti = true
				else:
					if (waktu < 0):
						var gambar_laser = Sprite.new()
						gambar_laser.texture = laserTeksturV
						gambar_laser.position = $"Laser Objek".global_position
						gambar_laser.position.y = $"Laser Objek".global_position.y + 0 * arah
						stak_laser.add_child(gambar_laser)
					else:
						waktu -= 1
						if (waktu == 0):
							$"Laser Objek".show()
							perpus.mainkan_sfx("laser")
#							var gambar_laser = Sprite.new()
#							gambar_laser.texture = laserTeksturV
#							gambar_laser.position = $"Laser Objek".global_position
#							gambar_laser.position.y = $"Laser Objek".global_position.y + 2 * arah
#							stak_laser.add_child(gambar_laser)
	else:
		$"Laser Objek/Sprite".hide()
		setelah_transisi = true
	pass

func _on_Laser_Objek_body_entered( body ):
	if ("Laser Bias" in body.name):
		body.aksi()
	pass # replace with function body
