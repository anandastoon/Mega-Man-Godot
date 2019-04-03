extends KinematicBody2D

const FRIKSI = 2

var level
var tipe_serang = 0
var megaman
var hp = 28
var risiko = 1
var darah_meter
var waktu_tunggu = -1
var arah = -1
var lama_waktu = 10
var kecepatan = Vector2(0, 0)
var kasus = "diam"
var status_anim = "Diem"
var waktu_sakit = 50
var status_sakit = 0
var stak_musuh
var tahan = false
var saklar = true # Untuk keperluan apapun
var pake_gravitasi = true
var ngamuk_mode = false
var setelah_ngamuk = false
var lapis_kolisi_holder
var kalah = false

var jarak_ke_megaman = 0

var konter = 0
var konter_mod = [0, 10]
var penghitung_konter = 0

var kec_plesholder = 0
var kec_tipe_serang = [0, 500, 0, 0]
var friksi = 0.77
var friksi_plesholder = 0.5

const LOMPAT_V = 430.0
const LOMPAT_H = 0

onready var bullet_kecil = preload("res://objek/Napalm Man/Bullet Kecil.tscn")
onready var bullet_kecil_bodi = preload("res://objek/Napalm Man/Bullet Kecil Bodi.tscn")
onready var matiM = preload("res://objek/Mega Man/Partikel Mati.tscn") 
onready var bullet_besar = preload("res://objek/Napalm Man/Bullet Besar.tscn")
onready var bullet_ledak = preload("res://objek/Napalm Man/Bullet Ledak.tscn")
onready var panggil_napalm = preload("res://objek/Napalm Man/Panggil Napalm.tscn")
onready var pemuncul_musuh = preload("res://objek/Pemuncul Musuh.tscn")

var boss_gimmick

func _ready():
	ganti_arah(-1)
	stak_musuh = get_node("../StakMusuh")
	boss_gimmick = get_node("../boss-gimmick")
	pass

func _process(delta):
	if (!tahan):
		if (tipe_serang == 0):
			if (kasus == "diam"):
				if (pewaktu_cantik (15)):
					menghadap_objek(megaman.position)
					kasus = "serang"
			if (kasus == "serang"):
				mainkan_anim("Nembak Depan")
				if ($Sprite.frame == 2):
					if (saklar):
						for i in range(3):
							var bko = bullet_kecil.instance()
							bko.kecH = 10
							bko.kecV = 3
							bko.arahV = i - 1
							bko.arahH = arah
							bko.position = Vector2((8 * arah), -7)
							add_child(bko)
						saklar = false
				if (!$AnimationPlayer.is_playing()):
					if (pewaktu_cantik (15)):
						mainkan_anim("Diem")
						saklar = true
						ganti_serangan(peluang_serang(1, 3, 4))
					
		if (tipe_serang == 1):
			if (kasus == "diam"):
				menghadap_objek(perpus.pos_kamera(true), true)
				mainkan_anim("Sliding")
				if ($Sprite.frame == 5):
					if (saklar):
						var blo = bullet_ledak.instance()
						blo.tipe_serang = 0
						blo.position = Vector2((global_position.x + 8 * arah), (global_position.y + 8))
						stak_musuh.add_child(blo)
						saklar = false
					kec_plesholder = kec_tipe_serang[tipe_serang]
					friksi_plesholder = FRIKSI
					kasus = "strik"
			if (kasus == "strik"):
				if (kec_plesholder > 0) :
					kec_plesholder -= friksi_plesholder
					friksi_plesholder += friksi
					if (konter % konter_mod[tipe_serang] == 0 && penghitung_konter < 3):
						var blo = bullet_besar.instance()
						blo.tipe_serang = 0
						blo.megaman = megaman
						blo.indeks = penghitung_konter + 1
						blo.mode_ngamuk = setelah_ngamuk
						blo.arah = arah
						blo.position = Vector2((global_position.x + 8 * arah), (global_position.y + 0))
						stak_musuh.add_child(blo)
						penghitung_konter += 1
					konter += 1
				else: 
					kec_plesholder = 0
					if (pewaktu_cantik (25)):
						menghadap_objek(megaman.position)
						kasus = "lompat"
				kecepatan.x = kec_plesholder * -arah
			if (kasus == "lompat" || kasus == "mendarat"):
				lompat("ganti tipe")
			if (kasus == "ganti tipe"):
				if (pewaktu_cantik (10)):
					ganti_serangan(peluang_serang(0, 2, 4))
					
		if (tipe_serang == 2):
			if (kasus == "diam"):
				menghadap_objek(megaman.position)
				if (pewaktu_cantik (5)):
					mainkan_anim("Nembak Atas")
					kasus = "serang"
			if (kasus == "serang"):
				if ($Sprite.frame == 1 && saklar):
					var blo = bullet_besar.instance()
					blo.tipe_serang = 1
					blo.megaman = megaman
					blo.arah = arah
					blo.position = Vector2((global_position.x + 8 * arah), (global_position.y + 0))
					stak_musuh.add_child(blo)
					saklar = false
				if (pewaktu_cantik (68)):
					kasus = "rehat"
			if (kasus == "rehat"):
				mainkan_anim("Diem")
				if (pewaktu_cantik (4)):
					kasus = "lompat"
			if (kasus == "lompat" || kasus == "mendarat"):
				lompat("ganti tipe")
			if (kasus == "ganti tipe"):
				menghadap_objek(megaman.position)
				if (pewaktu_cantik (10)):
					ganti_serangan(peluang_serang(0, 1, 3))
					
		if (tipe_serang == 3):
			if (kasus == "diam"):
				menghadap_objek(megaman.position)
				if (pewaktu_cantik (5)):
					mainkan_anim("Nembak Atas")
					kasus = "serang"
			if (kasus == "serang"):
				if ($Sprite.frame == 1 && saklar):
					var blo = bullet_besar.instance()
					blo.tipe_serang = 5 if setelah_ngamuk else 2
					blo.megaman = megaman
					blo.arah = arah
					blo.position = Vector2((global_position.x + 8 * arah), (global_position.y - 6))
					stak_musuh.add_child(blo)
					saklar = false
				if (pewaktu_cantik (48)):
					kasus = "rehat"
			if (kasus == "rehat"):
				mainkan_anim("Diem")
				if (pewaktu_cantik (4)):
					kasus = "lompat"
			if (kasus == "lompat" || kasus == "mendarat"):
				lompat("ganti tipe")
			if (kasus == "ganti tipe"):
				menghadap_objek(megaman.position)
				if (pewaktu_cantik (10)):
					ganti_serangan(peluang_serang(0, 2, 4))
					
		if (tipe_serang == 4):
			if (kasus == "diam"):
				menghadap_objek(megaman.position)
				if (pewaktu_cantik (15)):
					kasus = "lompat_awal"
			if (kasus == "lompat_awal"):
				mainkan_anim("Lompat")
				if ($Sprite.frame == 2):
					jarak_ke_megaman = ( position.x - megaman.position.x )
					$AnimationPlayer.stop()
					if (is_on_floor()):	kecepatan.y = -LOMPAT_V
					kasus = "nembak di udara"
			if (kasus == "nembak di udara"):
				kecepatan.x = 0
				if (kecepatan.y > 0): 
					mainkan_anim("Nembak Depan")
					kasus = "di udara"
			if (kasus == "di udara"):
				if ($Sprite.frame == 1 && saklar):
					var blo = bullet_kecil_bodi.instance()
					blo.tipe_serang = 0
					blo.arahH = 100
					blo.megaman = megaman
					blo.arah = arah
					blo.position = Vector2((global_position.x + 8 * arah), (global_position.y - 6))
					stak_musuh.add_child(blo)
					blo = bullet_kecil_bodi.instance()
					blo.tipe_serang = 0
					blo.megaman = megaman
					blo.arahH = 300
					blo.arah = arah
					blo.position = Vector2((global_position.x + 8 * arah), (global_position.y - 6))
					stak_musuh.add_child(blo)
					saklar = false
				pake_gravitasi = false
				kecepatan = Vector2(0, 0)
				menghadap_objek(megaman.position)
				if (pewaktu_cantik (25)):
					kasus = "jatuh"
					mainkan_anim("Lompat")
					saklar = true
			if (kasus == "jatuh"):
				pake_gravitasi = true
				menghadap_objek(megaman.position)
				if (is_on_floor()):
					mainkan_anim("Nembak Depan")
					if ($Sprite.frame == 1 && saklar):
						var blo = bullet_besar.instance()
						blo.tipe_serang = 3
						blo.megaman = megaman
						blo.arah = arah
						blo.position = Vector2((global_position.x + 8 * arah), (global_position.y - 6))
						stak_musuh.add_child(blo)
						saklar = false
					if (pewaktu_cantik (70)):
						mainkan_anim("Diem")
						kasus = "lompat"
			if (kasus == "lompat" || kasus == "mendarat"):
				lompat("ganti tipe")
			if (kasus == "ganti tipe"):
				menghadap_objek(megaman.position)
				if (pewaktu_cantik (15)):
					ganti_serangan(peluang_serang(1, 2, 3))
					
		if (tipe_serang == 5):
			if (kasus == "diam"):
				menghadap_objek(megaman.position)
				if (pewaktu_cantik (5)):
					mainkan_anim("Intro")
				if (pewaktu_cantik (95)):
					var npl = panggil_napalm.instance()
					npl.napalm_man = self
					npl.position = Vector2(perpus.pos_kamera(true).x, perpus.pos_kamera(true).y + perpus.lebar_asli_layar)
					get_parent().add_child(npl)
					var pmu = pemuncul_musuh.instance()
					pmu.indeks = "Laser"
					pmu.arg = 21
					pmu.position = Vector2((global_position.x + 8 * arah), (global_position.y + 0))
					get_parent().add_child(pmu)
					kasus = "serang"
					mainkan_anim("Lompat")
					lapis_kolisi_holder = collision_layer
			if (kasus == "serang"):
				if ($Sprite.frame == 2):
					if (position.y > -50): kecepatan.y = -400
					else: kecepatan.y = 0
					pake_gravitasi = false
					$AnimationPlayer.stop()
					collision_layer = 16
				if (pewaktu_cantik (107)):
					boss_gimmick.position.x = 0
					if (saklar):
						for i in range(4):
							var bko = bullet_ledak.instance()
							bko.bahaya = false
							bko.position = Vector2(perpus.pos_kamera().x + 65 * i + 32, perpus.pos_kamera().y + 240)
							get_parent().add_child(bko)
					kasus = "WTF"
			if (kasus == "WTF" && setelah_ngamuk):
				collision_layer = lapis_kolisi_holder
				position.y = perpus.pos_kamera().y - 140
				pake_gravitasi = true
				kasus = "akhirnya"
			if (kasus == "akhirnya"):
				if (is_on_floor()):
					mainkan_anim("Diem")
					menghadap_objek(megaman.position)
					ganti_serangan(0)
				pass
				
		if (tipe_serang == 10):
			menghadap_objek(Vector2(perpus.pos_kamera(true).x, 0))
			if (kasus == "diam"):
				kasus = "lompat"
				print("Hah?")
			if (kasus == "lompat" || kasus == "mendarat"):
				lompat("ganti tipe")
			if (kasus == "ganti tipe"):
				mati()
				pass
				
		if (pake_gravitasi):
			kecepatan.y += perpus.GRAVITASI * delta
		move_and_slide(kecepatan, Vector2(0, -1))
		
		if (status_sakit > 0):
			status_sakit -= 1
			if (status_sakit % 2 == 0):
				$Sprite.visible = true
				$Sprite2.visible = false
			else:
				$Sprite.visible = false
				$Sprite2.visible = true
			if (status_sakit == 1):
				status_sakit = 0
				$Sprite.visible = true
				$Sprite2.visible = false
		pass
		
		if ($Area2D.overlaps_body(megaman)):
			megaman.kena(risiko)
		
	pass
	
func pewaktu_cantik (waktu):
	if (!kalah && tipe_serang < 10):
		if (waktu_tunggu == -1): waktu_tunggu = waktu
		if (waktu_tunggu > 0):
			waktu_tunggu -= 1
			if (waktu_tunggu == 0):
				waktu_tunggu = -1
				return true
	else:
		return true
		waktu_tunggu = -1
	return false
	pass
	
func ganti_serangan(tipe):
	tipe_serang = tipe
	saklar = true
	penghitung_konter = 0
	konter = 0
	if (hp <= 15 && !ngamuk_mode):
		ngamuk_mode = true
		tipe_serang = 5
		kasus = "diam"
	else:
		match tipe_serang:
			0, 1, 2, 3, 4, 10: 
				kasus = "diam"
			
func kena(darah = 0):
	perpus.mainkan_sfx("musuh_kena")
	if (status_sakit == 0):
		status_sakit = waktu_sakit
		hp -= darah
		darah_meter.set_darah(hp)
		if (hp <= 0):
			hp = 0
		if (hp == 0):
			kalah = true
			mainkan_anim("Diem")
			ganti_serangan(10)
			return
	pass

func _on_Area2D_area_entered( area ):
	if ("Mega Buster" in area.name):
		if (tipe_serang == 5 || hp == 0):
			area.repel()
		else:
			area.queue_free()
			kena(1)
	pass # replace with function body
	
func menghadap_objek(posisi, kebalik = false):
	var statusKebalik = 1
	if (kebalik): statusKebalik = -1
	if (posisi.x > position.x): ganti_arah(1 * statusKebalik)
	else: ganti_arah(-1 * statusKebalik)

func mainkan_anim(anim):
	if (status_anim != anim):
		status_anim = anim
		$AnimationPlayer.play(status_anim)
		
func ganti_arah(arah_arg):
	arah = arah_arg
	if (arah > 0): $Sprite.set_flip_h(true)
	else: $Sprite.set_flip_h(false)
	
func lompat (kasus_berikutnya) :
	if (kasus == "lompat"):
		mainkan_anim("Lompat")
		if ($Sprite.frame == 2):
			if (tipe_serang == 10):
				jarak_ke_megaman = ( position.x - perpus.pos_kamera(true).x )
			else:
				jarak_ke_megaman = ( position.x - megaman.position.x )
			$AnimationPlayer.stop()
			if (is_on_floor()):	kecepatan.y = -LOMPAT_V
			kasus = "mendarat"
	if (kasus == "mendarat"):
		kecepatan.x = (jarak_ke_megaman / ((-1 * 2 * LOMPAT_V) / (perpus.GRAVITASI) ))
		if (kecepatan.y > 0 && is_on_floor()): 
			kecepatan = Vector2(0, 0)
			mainkan_anim("Diem")
			kasus = kasus_berikutnya
	
func mati():
	status_sakit = 0
	perpus.mainkan_musik("stop")
	$"../Bgm Raja".stop()
	perpus.mainkan_sfx("mati")
	for i in 16:
		var mati_obj = matiM.instance()
		mati_obj.position = position
		mati_obj.tampil(i)
		get_parent().get_node("StakMusuh").add_child(mati_obj)
	megaman.level.raja_selesai()
	var blo = bullet_besar.instance()
	blo.tipe_serang = 10
	blo.megaman = megaman
	blo.position = global_position
	stak_musuh.add_child(blo)
	queue_free()
	
func peluang_serang(a, b, c):
	var peluang = [a, b, c]
	return peluang[randi() % peluang.size()]

func _on_Area2D_body_entered( body ):
	if (body.name == perpus.nama_megaman):
		body.kena(1)
	pass # replace with function body
