extends KinematicBody2D

const KECEPATAN_V = 530
const KECEPATAN_H = 10
const KECEPATAN_H2 = 100
const WAKTU_MANTUL = 200
const WAKTU_POKPROASH = 18

var megaman
var arah = 1
var mantul = 0
var tipe_serang = 0
var kecepatan = Vector2(0,0)
var pokproash = 0
var indeks = 0
var status = ""
var mode_ngamuk = false
onready var bullet_ledak = preload("res://objek/Napalm Man/Bullet Ledak.tscn")
onready var ledakan_kecil = preload("res://objek/Napalm Man/Ledakan Kecil.tscn")
onready var bullet_besar = load("res://objek/Napalm Man/Bullet Besar.tscn")

func _ready():
	$AnimationPlayer.play("Anim")
	megaman = perpus.megaman
	pass

func _process(delta):
	if (tipe_serang == 0):
		kecepatan.y += perpus.GRAVITASI * delta
		if (status == ""):
			kecepatan.y = -KECEPATAN_V;
			
			if (mode_ngamuk):
				kecepatan.x = (KECEPATAN_H2 + indeks * 70) * arah;
			else:
				kecepatan.x = KECEPATAN_H * arah;
				
			status = "ok"
			
		if (is_on_wall()): kecepatan.x *= -1
	
		if ($Area2D.overlaps_body(megaman) || is_on_floor()):
			var bullet_ledakM = bullet_ledak.instance()
			bullet_ledakM.position = global_position
			bullet_ledakM.tipe_serang = 0
			get_parent().add_child(bullet_ledakM)
			queue_free()
		pass
		
	if (tipe_serang == 1):
		kecepatan.y += perpus.GRAVITASI * delta
		if (status == ""):
			kecepatan.y = -KECEPATAN_V * 0.9;
			status = "ok"
		if (kecepatan.y > 0):
			var bullet_ledakM = bullet_ledak.instance()
			bullet_ledakM.position = global_position
			bullet_ledakM.tipe_serang = 0
			get_parent().add_child(bullet_ledakM)
			for i in range(12):
				var bko = ledakan_kecil.instance()
				bko.sudut_dir = i * (360 / 12)
				bko.position = global_position
				bko.tipe_serang = 1
				bko.tampil()
				get_parent().add_child(bko)
			queue_free()
		
	if (tipe_serang == 2):
		if (status == ""):
			mantul = WAKTU_MANTUL
			kecepatan.y = -220;
			kecepatan.x = 220 * arah;
			status = "ok"
		if (status == "ok"): mantul -= 1
		if (is_on_ceiling() || is_on_floor()): 
			kecepatan.y *= -1
		if (is_on_wall() || position.x >= perpus.pos_kamera().x + perpus.lebar_asli_layar - 24): 
			kecepatan.x *= -1
			mantul -= 1
		if ( (mantul <= 0 && position.y < perpus.pos_kamera(true).y - 50) || $Area2D.overlaps_body(megaman)):
			var bullet_ledakM = bullet_ledak.instance()
			bullet_ledakM.position = global_position
			bullet_ledakM.tipe_serang = 0
			get_parent().add_child(bullet_ledakM)
			for i in range(12):
				var bko = ledakan_kecil.instance()
				bko.sudut_dir = i * (360 / 12)
				bko.position = global_position
				bko.tipe_serang = 1
				bko.tampil()
				get_parent().add_child(bko)
			queue_free()
		
	if (tipe_serang == 3):
		collision_layer = 16
		visible = false
		if (status == ""):
			kecepatan.x = 100 * arah;
			pokproash -= 1
			if (pokproash < 0):
				pokproash = WAKTU_POKPROASH
				var bko = bullet_ledak.instance()
				bko.position = global_position
				get_parent().add_child(bko)
			if (position.x < perpus.pos_kamera().x + perpus.LEBAR_BLOK || position.x > perpus.pos_kamera().x + perpus.lebar_asli_layar + perpus.LEBAR_BLOK):
				queue_free()
				
	if (tipe_serang == 4):
		kecepatan.y += perpus.GRAVITASI * delta
		if (is_on_floor()):
			var bko = bullet_ledak.instance()
			bko.position = global_position
			get_parent().add_child(bko)
			queue_free()
		pass
		
	if (tipe_serang == 5):
		kecepatan.y = -KECEPATAN_V
		if (position.y < perpus.pos_kamera().y):
			for n in range(5):
				var bko = bullet_besar.instance()
				bko.position.x = perpus.pos_kamera(true).x + ((n - 2) * 49)
				bko.position.y = perpus.pos_kamera().y - 10
				bko.tipe_serang = 4
				get_parent().add_child(bko)
			queue_free()
		pass
		
	if (tipe_serang == 10):
		if (status == "" || is_on_floor()):
			kecepatan.y = -KECEPATAN_V
			status = "ok"
		kecepatan.y += perpus.GRAVITASI * delta
		pass
			
	move_and_slide(kecepatan, Vector2(0,-1))
	if ($Area2D.overlaps_body(megaman) && visible):
		if (megaman.mode_kinematis):
			megaman.kena(28)
			var bko = bullet_ledak.instance()
			bko.position = global_position
			get_parent().add_child(bko)
			queue_free()
		else: megaman.kena(1)

func _on_Area2D_area_exited(area):
	if (area.name == perpus.nama_kamera):
		queue_free()
	pass # replace with function body
