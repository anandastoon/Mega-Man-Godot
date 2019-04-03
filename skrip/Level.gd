extends Node2D

# Ini berhubungan dengan level, layar, dan kamera
const RAJA_SELESAI_KONTER = 240

var level_data
var kamera
var megaman
var layar = 0
var layarGUI
var gambar_flag = false
var gambar_tekstur
var gambar_posisi
var cekpoin = 1
var transisi_balik = false
var gulir_luas = false
var cekpoin_berikutnya = 0
var raja_sls_konter = 0

var objek_pintu
var transisi_pintu_raja = false
var kecepatan_transisi_mm = 0

#Gulir
var gulir_ke = 0
var cek_gulir = 0 # 0: tidak ada gulir, 1: Gulir standar, 2: Gulir Balik, digunakan untuk cek mulai gulir
var arah_gulir = ""
var sesi_gulir # Indeks di level gulir 0-7
var kamera_bergerak = false
var sisi_batas = [0, 0, 0, 0] #untuk menentukan batas kamera

#khusus drawing laser
onready var stak_laser = get_node("StakLaser")

func _ready():
	#Mainkan musik
	perpus.mainkan_musik("play")
	level_data = perpus.ambil_level_data(perpus.level)
	
	kamera = $Camera2D
	megaman = $Megaman
	layarGUI = $Camera2D/Label
	
	kamera.position = Vector2(level_data['cekpoin'][cekpoin][0] * perpus.lebar_asli_layar, level_data['cekpoin'][cekpoin][1] * perpus.lebar_asli_layar) + Vector2(perpus.setengah_layar, perpus.setengah_layar)
	gulir_ke = level_data['cekpoin'][cekpoin][2]
	
	sesi_gulir = int(level_data['gulir'][gulir_ke])
	sisi_batas[1] = perpus.pos_kamera().x + level_data['banyak_gulir'][gulir_ke] * perpus.lebar_asli_layar
	sisi_batas[3] = perpus.pos_kamera().x
	sisi_batas[2] = perpus.pos_kamera().y + level_data['banyak_gulir'][gulir_ke] * perpus.lebar_asli_layar
	sisi_batas[0] = perpus.pos_kamera().y
	
	if (sesi_gulir % 3 == 0):
		kamera.get_node("Tembok Kanan/CollisionShape2D").disabled = true
	if (sesi_gulir % 7 == 0):
		kamera.get_node("Tembok Kiri/CollisionShape2D").disabled = true
	
func reset():
	perpus.mainkan_musik("play")
	#Hapus seluruh musuh
	for i in get_node("StakMusuh").get_children():
		i.queue_free()
		
	kamera.position = Vector2(level_data['cekpoin'][cekpoin][0] * perpus.lebar_asli_layar, level_data['cekpoin'][cekpoin][1] * perpus.lebar_asli_layar) + Vector2(perpus.setengah_layar, perpus.setengah_layar)
	gulir_ke = level_data['cekpoin'][cekpoin][2]
	
	selesai_transisi()

func _process(delta):
	
	if (raja_sls_konter > 0):
		raja_sls_konter -= 1
		if (raja_sls_konter == 0):
			get_node("Bgm Raja").stop()
			get_node("Bgm Menang").play()
			megaman.bisa_kontrol = false
			megaman.kecepatan.x = 0
			megaman.persiapan_kinematis()
			raja_sls_konter = -1
		pass
	
	# Pengaturan Kamera Realtime
	if (!perpus.transisi):
		
		if (megaman.position.x < sisi_batas[1] - perpus.setengah_layar &&
			megaman.position.x > sisi_batas[3] + perpus.setengah_layar):
			kamera.position.x = megaman.position.x
			kamera_bergerak = true
		else:
			kamera_bergerak = false
			# Mentok kiri
			if  (megaman.position.x <= sisi_batas[3] + perpus.setengah_layar):
				kamera.position.x = sisi_batas[3] + perpus.setengah_layar
			# Mentok kanan
			else:
				kamera.position.x = sisi_batas[1] - perpus.setengah_layar
			
		# Waktunya transisi kamera ala si Geblek yay!
		# transisi kiri
		if (megaman.position.x < kamera.position.x - perpus.setengah_layar):
			if (cek_gulir("kiri") > 0):
				arah_gulir = "kiri"
				mulai_transisi()
				
		# transisi kanan
		if (megaman.position.x > kamera.position.x + perpus.setengah_layar):
			cek_gulir = cek_gulir("kanan")
			if (cek_gulir("kanan") > 0):
				arah_gulir = "kanan"
				if (cek_gulir == 1):
					mulai_transisi()
				elif (cek_gulir == 2):
					mulai_transisi(true)
			
		# transisi bawah
		if (megaman.position.y + 6 > kamera.position.y + perpus.setengah_layar && !kamera_bergerak):
			if (!megaman.mati):
				cek_gulir = cek_gulir("bawah")
				if (cek_gulir("bawah") > 0):
					arah_gulir = "bawah"
					if (cek_gulir == 1):
						mulai_transisi()
					elif (cek_gulir == 2):
						mulai_transisi(true)
			
		# transisi atas
		if (megaman.position.y - 6 < kamera.position.y - perpus.setengah_layar && !kamera_bergerak):
			if (!megaman.mati && megaman.lagi_manjat):
				cek_gulir = cek_gulir("atas")
				if (cek_gulir("atas") > 0):
					arah_gulir = "atas"
					if (cek_gulir == 1):
						mulai_transisi()
					elif (cek_gulir == 2):
						mulai_transisi(true)
		
	else: #yay transisi
		if (transisi_pintu_raja):
			kecepatan_transisi_mm = perpus.kec_mm_transisi_pintu_raja
		else:
			kecepatan_transisi_mm = perpus.kec_mm_transisi
			
		match (arah_gulir):
			"atas": 
				kamera.position.y -= perpus.kec_transisi
				megaman.position.y -= kecepatan_transisi_mm
				if (kamera.position.y <= sisi_batas[0] - perpus.setengah_layar):
					kamera.position.y = sisi_batas[0] - perpus.setengah_layar
					selesai_transisi(transisi_balik)
					
			"kanan": 
				kamera.position.x += perpus.kec_transisi
				megaman.position.x += kecepatan_transisi_mm
				if (kamera.position.x > sisi_batas[1] + perpus.setengah_layar):
					kamera.position.x = sisi_batas[1] + perpus.setengah_layar
					selesai_transisi(transisi_balik)

			"bawah": #bawah
				kamera.position.y += perpus.kec_transisi
				megaman.position.y += kecepatan_transisi_mm
				if (kamera.position.y >= sisi_batas[2] + perpus.lebar_asli_layar / 2):
					kamera.position.y = sisi_batas[2] + perpus.lebar_asli_layar / 2
					selesai_transisi(transisi_balik)
					
			"kiri": #kiri
				kamera.position.x -= perpus.kec_transisi
				megaman.position.x -= kecepatan_transisi_mm
				if (kamera.position.x < sisi_batas[3] - perpus.setengah_layar):
					kamera.position.x = sisi_batas[3] - perpus.setengah_layar
					selesai_transisi(transisi_balik)
		pass
		
	kamera.align()
	pass
	
func mulai_transisi(balik = false) :
	transisi_balik = balik
	megaman.transisi_kamera(true)
	perpus.transisi = true
	if (transisi_balik): gulir_ke -= 1
	else: gulir_ke += 1
	kamera.get_node("Tembok Kiri/CollisionShape2D").disabled = false
	kamera.get_node("Tembok Kanan/CollisionShape2D").disabled = false
	pass
	
func mulai_transisi_pintu_raja(objek, arah_transisi = "kanan"):
	objek_pintu = objek
	arah_gulir = arah_transisi
	transisi_pintu_raja = true
	mulai_transisi()
	pass
	
func selesai_transisi(balik = false):
	if (transisi_pintu_raja):
		transisi_pintu_raja = false
		objek_pintu.status_pintu("tutup")
	else:
		megaman.transisi_kamera(false)
		
	if (level_data['cekpoin'].size() > cekpoin + 1):
		cekpoin_berikutnya = level_data['cekpoin'][cekpoin + 1][2]
	
	perpus.transisi = false
	sesi_gulir = int(level_data['gulir'][gulir_ke])
	
	if (gulir_ke == cekpoin_berikutnya && gulir_ke != level_data['cekpoin'][cekpoin][2]): 
		cekpoin += 1
		perpus.mainkan_sfx("nyawa")
	
	var banyak_gulir = level_data['banyak_gulir'][gulir_ke] - 1
	sisi_batas[0] = kamera.position.y - perpus.setengah_layar
	sisi_batas[1] = kamera.position.x + perpus.setengah_layar
	sisi_batas[2] = kamera.position.y + perpus.setengah_layar
	sisi_batas[3] = kamera.position.x - perpus.setengah_layar
	if (!balik):
		if (sesi_gulir % 3 == 0):
			sisi_batas[1] += banyak_gulir * perpus.lebar_asli_layar
		if (sesi_gulir % 7 == 0):
			sisi_batas[3] -= banyak_gulir * perpus.lebar_asli_layar
	else:
		if (sesi_gulir % 3 == 0):
			sisi_batas[3] -= banyak_gulir * perpus.lebar_asli_layar
		if (sesi_gulir % 7 == 0):
			sisi_batas[1] += banyak_gulir * perpus.lebar_asli_layar
	
	if (sesi_gulir % 3 == 0):
		kamera.get_node("Tembok Kanan/CollisionShape2D").disabled = true
	if (sesi_gulir % 7 == 0):
		kamera.get_node("Tembok Kiri/CollisionShape2D").disabled = true
			
	for i in stak_laser.get_children():
		i.queue_free()
	pass
	
func cek_gulir(arg):
	if (arg == "bawah"):
		if (int(sesi_gulir) % 2 == 0):
			return 2
		if (gulir_ke + 1 <= level_data['gulir'].size()):
			if (int(level_data['gulir'][gulir_ke + 1]) % 5 == 0):
				return 1
				
	if (arg == "atas"):
		if (int(sesi_gulir) % 5 == 0):
			return 2
		if (gulir_ke + 1 <= level_data['gulir'].size()):
			if (int(level_data['gulir'][gulir_ke + 1]) % 2 == 0):
				return 1

	if (arg == "kanan"):
		if (gulir_ke + 1 <= level_data['gulir'].size()):
			if (int(level_data['gulir'][gulir_ke + 1]) % 3 == 0):
				return 1
		if (int(sesi_gulir) % 3 == 0):
			return 2

	if (arg == "kiri"):
		if (gulir_ke + 1 <= level_data['gulir'].size()):
			if (int(level_data['gulir'][gulir_ke + 1]) % 7 == 0):
				return 1
		if (int(sesi_gulir) % 7 == 0):
			return 2

	return 0
	
func gambar_sesuatu(tekstur, posisi):
	gambar_flag = true
	gambar_tekstur = tekstur
	gambar_posisi = posisi
	update()
	
func raja_selesai():
	raja_sls_konter = RAJA_SELESAI_KONTER
	pass
	
func _draw():
	if (gambar_flag):
		draw_texture(gambar_tekstur, gambar_posisi)
	pass
	
func _input(event):
	if (event is InputEventKey and event.is_pressed() and event.scancode == KEY_A):
		print(kamera.position)
	pass
