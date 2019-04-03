extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const WAKTU_MULAI = 120
const KECEPATAN_H = 98
const KECEPATAN_SLIDE = 200
const WAKTU_SLIDE = 15
const WAKTU_NEMBAK = 10
const WAKTU_KENA = 35
const WAKTU_SAKIT = 100
const KECEPATAN_V = 320
const KECEPATAN_TANGGA = 100
const LANTAI_NORMAL = Vector2(0, -1)
const ATAP_NORMAL = Vector2(0, 1)
const WAKTU_TUNGGU_KINEMATIS = 320

var waktu_tgg_kinematis = 0
var mode_kinematis = false
var arah_kinematis = 0

var kamera
var dalam_kamera = true

var hp = 28
var status_megageblek = "siap"
var posisi_teleportasi
var waktu_status = 0
var waktu_mati = 0
var waktu_kena = 0
var waktu_sakit = 0
var gravitasi = perpus.GRAVITASI
var jalan = false
var lompat = false
var lagi_lompat = false
var lebar_sprite = 32
var nembak = 0
var slide = 0
var di_air = "keluar"
var licin = false
var licin_var = 0.0 #Berapa licin yang diset
var kecepatan_terakhir = 0.0 #Untuk dikopi ke licin
var arah_terakhir = 0 #Untuk dikopi ke licin

var di_tangga = false # Godot nggak ada sensor di kinematic, fkkk
var lagi_manjat = false
var posisi_tangga = 0
var tangga_atas = false
var tangga_atas_anim = false

var bisa_bergerak = false
var bisa_kontrol = true
var kecepatan_tersimpan = [0, 0] #Keperluan transisi dan immobile
var slide_offset = 2 # Sprite hack agar slide terlihat menempel di lantai
var arah_slide = 0 # Jika jalan berlawanan, batalkan slide
var lompat_keatas = false # Hack untuk ketika menyentuh atap sprite tetep lompat bukan diem.
var status_anim = ""
var mati = 0
var arah = 1 # Direksi, kanan = 1, kiri = -1
var tangga_atas_obj #Objek tangga atas

#Fading
var fading
var alpha = 0

const WAKTU_BUBBLE = 60
var waktububble = 0

onready var matiM = preload("res://objek/Mega Man/Partikel Mati.tscn") 
onready var tembakanM = preload("res://objek/Mega Man/Mega Buster.tscn") 
onready var slideM = preload("res://objek/Mega Man/Partikel Slide.tscn") 
onready var airM = preload("res://objek/Mega Man/Partikel Air.tscn")  
onready var bubbleM = preload("res://objek/Mega Man/Partikel Bubble.tscn")  
onready var fadingM = preload("res://objek/Fading.tscn") 
onready var darahMeterM = get_parent().get_node("Camera2D/Darah Meter")

onready var level = get_parent()

#Bedanya gerakan & kecepatan, kalo gerakan adalah gerakan real dari kecepatan dengan gravitasi
var kecepatan = Vector2()
var gerakan = Vector2()

func _ready():
	kamera = get_parent().get_node("Camera2D")
	mainkan_anim("Ready")
	waktu_status = WAKTU_MULAI
	$CollBiasa.disabled = true
	perpus.megaman = self
	pass
	
func _physics_process(delta):
	dalam_kamera = (position.y + 16 >= kamera.position.y - perpus.setengah_layar)
	
	if (status_megageblek == "siap"):
		darahMeterM.set_darah(28)
		position = kamera.position
		status_megageblek = "mulai"
	
	if (status_megageblek == "mulai"):
		waktu_status -= 60 * delta
		if (waktu_status < 0):
			waktu_status = 0
			status_megageblek = "teleportasi"
			posisi_teleportasi = level.level_data['teleportasi'][level.cekpoin]
			position.y = kamera.position.y - perpus.setengah_layar
	
	if (status_megageblek == "teleportasi"):
		mainkan_anim("Teleportasi")
		move_and_slide(Vector2(0, 600))
		if (position.y >= perpus.pos_kamera().y + posisi_teleportasi * 16):
			position.y = perpus.pos_kamera().y + posisi_teleportasi * 16
			status_megageblek = "teleportasi 2"
			$Sprite.position.y -= 2
			move_and_slide(Vector2(0, 0))
			perpus.mainkan_sfx("telepor")
			print($CollBiasa.position)
			pass
	
	if (status_megageblek == "teleportasi 2"):
		mainkan_anim("Teleportasi_Mulai")
	
	if (status_megageblek == "mulai normal"):
		$Sprite.position.y += 2
		mati = 0
		kecepatan.y = 0
		bisa_bergerak = true
		status_megageblek = "normal"
		$CollBiasa.disabled = false
		kamera.get_node("AreaKamera/CollisionShape2D").disabled = false
	
	if (status_megageblek == "fading mati"):
		fading = fadingM.instance()
		fading.position = kamera.position
		get_parent().add_child(fading)
		status_megageblek = "fading aksi"
	
	if (status_megageblek == "fading aksi"):
		if (alpha < 1): alpha += 0.1
		else: 
			alpha = 1
			status_megageblek = "fading reaksi"
			level.reset()
			reset()
			fading.position = kamera.position
			print(alpha)
			
		fading.modulate = Color(1,1,1, alpha)

	if (status_megageblek == "fading reaksi"):
		if (alpha > 0): alpha -= 0.1
		else:
			status_megageblek = "mulai"
			fading.queue_free()
		fading.modulate = Color(1,1,1, alpha)
			
	if (nembak > 0):
		nembak -= 1
	
	# BAGIAN: Kena musuh
	if (waktu_kena > 0):
		if (is_on_floor()):
			kecepatan.y = 0
		gerakan = kecepatan

		if (!perpus.transisi):
			waktu_kena -= 1
			kecepatan.x = -20 * arah
			kecepatan.y += gravitasi * delta
			move_and_slide(gerakan, LANTAI_NORMAL, 0)
		else:
			kecepatan.x = 0
			kecepatan.y = 0
		if (waktu_kena == 0):
			if (is_on_floor()):
				kecepatan.y = 0
			kecepatan.x = 0
			bisa_bergerak = true
			
	if (waktu_sakit > 0):
		if (waktu_kena == 0):
			waktu_sakit -= 1
			$Sprite.visible = !$Sprite.visible
		pass
	
	if (mati == 0 && bisa_bergerak && !mode_kinematis):

		# Keyboard Stuff
		var jalan_kiri = Input.is_action_pressed("kiri")
		var jalan_kanan = Input.is_action_pressed("kanan")
		var naik_atas = Input.is_action_pressed("atas")
		var naik_bawah = Input.is_action_pressed("bawah")

		if (naik_bawah && tangga_atas && slide == 0 && bisa_kontrol):
			if (!lagi_manjat):
				kecepatan.x = 0
				di_tangga = true
				lagi_manjat = true
				position.x = posisi_tangga
				mainkan_anim("Tangga Atas")
				position.y = tangga_atas_obj.position.y - 16
				kecepatan = Vector2(0, 0)
				
		if (naik_atas):
			if (di_tangga):
				if (dalam_kamera):
					kecepatan = Vector2(0, 0)
					position.x = posisi_tangga
					lagi_manjat = true
			else:
				lagi_manjat = false
		
		if (naik_bawah && !di_tangga):
			lagi_manjat = false

		#Khusus skrip tangga realtime
		if (lagi_manjat):
			#Mengatur animasi apakah sedang di tangga atas atau nggak
			if (tangga_atas_anim): mainkan_anim("Tangga Atas")
			else: mainkan_anim("Manjat")
			
			#Jika Keyboard atas dan bawah ditekan
			if ( (naik_atas || naik_bawah) && nembak == 0 && bisa_kontrol):
				kontrol_anim("Lanjut")
				if (naik_atas && dalam_kamera):
					kecepatan.y -= KECEPATAN_TANGGA
				else: kecepatan.y = 0
				if (naik_bawah):
					kecepatan.y = KECEPATAN_TANGGA
					
				#Jika berada di atas tangga
				if (tangga_atas):
					if (position.y < tangga_atas_obj.position.y - 8):
						tangga_atas_anim = true
					else:
						tangga_atas_anim = false
					
					if (position.y < tangga_atas_obj.position.y - 15 && naik_atas):
						kecepatan.y = 0
						position.y = tangga_atas_obj.position.y - 24.16
						lagi_manjat = false
			else: 
				kontrol_anim("Jeda")
				kecepatan.y = 0
			if (Input.is_action_just_pressed("lompat") && !naik_atas):
				lagi_manjat = false
				kontrol_anim("Lanjut")
		elif (tangga_atas_anim): tangga_atas_anim = false

		#Lompat
		if (Input.is_action_just_pressed("lompat") && !Input.is_action_pressed("bawah")):
			lompat = true
			lagi_lompat = true
		
		if (Input.is_action_just_released("lompat")):
			if (kecepatan.y < 0):
				kecepatan.y = 0
		
		#Nembak
		if (Input.is_action_just_pressed("nembak") && slide == 0):
			mulai_nembak()

		#Slide
		if (Input.is_action_just_pressed("lompat") && Input.is_action_pressed("bawah") && slide == 0 && is_on_floor()):
			mulai_slide()

		if ( (jalan_kiri || jalan_kanan) && !lagi_manjat && bisa_kontrol) :
			
			#Hilangkan Slide
			if (jalan_kiri): ganti_arah(-1)
			else: ganti_arah(1)
			jalan = true
			if (slide > 0 && arah_slide != arah):
				selesai_slide()
			else:
				if (slide == 0 && licin_var <= 0):
					kecepatan.x = KECEPATAN_H * arah
					kecepatan_terakhir = kecepatan.x
					arah_terakhir = arah
					
		else:
			jalan = false
			
		#Kodingan licin
		if (Input.is_action_just_released("kanan") || Input.is_action_just_released("kiri")):
			if (licin):
				licin_var = abs(kecepatan_terakhir)

		if (licin_var > 0 && waktu_sakit == 0):
			kecepatan.x = licin_var * arah_terakhir
			licin_var -= 2
			if (licin_var <= 0):
				arah_terakhir = 0
		
		if (!lagi_manjat):
			kecepatan.y += gravitasi * delta
		
		gerakan = kecepatan
		
		if (kecepatan.y >= 0):
			move_and_slide(gerakan, LANTAI_NORMAL, 0)
		else:
			move_and_slide(gerakan, ATAP_NORMAL, 0)
			
		#Apabila di lantai
		if (is_on_floor()):
			if(lagi_manjat): 
				if (naik_atas):
					return
				lagi_manjat = false
			#Matikan status lompat dan mainkan suara mendarat
			if (kecepatan.y > 35):
				lagi_lompat = false
				perpus.mainkan_sfx("mendarat")
				
			kecepatan.y = 0
			
			if (lompat_keatas == false):
				if (!jalan):
					if (nembak > 0):
						mainkan_anim("Nembak")
					else:
						mainkan_anim("Diem")
					
				# Jika sedang lompat dan bukan slide
				if (lompat):
					#Hilangkan Slide
					if (slide > 0): selesai_slide(false)
						
					gerakan.y = 0
					kecepatan.y = 0
					kecepatan.y -= KECEPATAN_V
					if (nembak > 0):
						mainkan_anim("Jatuh_Nembak")
					else:
						mainkan_anim("Jatuh")
				elif (jalan):
					if (nembak > 0):
						mainkan_anim("Jalan_Nembak")
					else:
						mainkan_anim("Jalan")
					
		elif (!lagi_manjat): #Jika di udara
			if (licin_var > 0): selesai_licin()
			if (kecepatan.y > 600): kecepatan.y = 600
			if (nembak > 0):
				mainkan_anim("Jatuh_Nembak")
			else:
				mainkan_anim("Jatuh")
			#Matikan seluruh slide
			if (slide > 0):
				selesai_slide(false)
				if test_move(transform, Vector2(0, -1)):
					position.y += 5
		
		elif (lagi_manjat):
			if (jalan_kiri):
				arah = -1
			if (jalan_kanan):
				arah = 1
			ganti_arah(arah)
			if (nembak > 0):
				mainkan_anim("Manjat_Nembak")
	elif (mati == 1 && status_megageblek == "normal"):
		if (waktu_mati > 0):
			waktu_mati -= 1
			if (waktu_mati == 0):
				status_megageblek = "fading mati"
		pass

	#Kalo ketemu jurang, mati
	if (position.y - 16 > kamera.position.y + perpus.lebar_asli_layar / 2):
			mati()
			
	# Kurangi waktu slide
	if (slide > 0 && waktu_kena == 0):
		$Sprite.position.y = slide_offset
		kecepatan.x = KECEPATAN_SLIDE * arah
		mainkan_anim("Kepleset");
		if (!perpus.transisi): slide -= 1;
		if (is_on_wall()):
			slide = 0
		if (slide == 0):
			selesai_slide()
		pass
		
	#Ingat, lompat hanya ditekan sekali saja
			
	if (lompat):
		lompat = false
	
	lompat_keatas = true if (kecepatan.y < 0) else false
	
	#Partikel Bubble
	if (di_air == "masuk" && mati == 0):
		waktububble -= 1
		if (waktububble <= 0):
			var bubble_obj = bubbleM.instance()
			bubble_obj.position = position
			get_parent().add_child(bubble_obj)
			waktububble = WAKTU_BUBBLE
			
	if (waktu_tgg_kinematis > 0 && bisa_bergerak):
		waktu_tgg_kinematis -= 1
		if (waktu_tgg_kinematis == 0):
			mainkan_anim("Jalan")
			if (perpus.pos_kamera(true).x > position.x): arah_kinematis = -1
			else: arah_kinematis = 1
			waktu_tgg_kinematis = -1
			mode_kinematis = true			
		pass
	
	if (mode_kinematis && mati == 0):
		if (is_on_floor()):
			mainkan_anim("Jalan")
		else:
			mainkan_anim("Jatuh")
			
		if (is_on_wall() && is_on_floor()):
			kecepatan.y = -KECEPATAN_V
			
		kecepatan.y += gravitasi * delta
		gerakan = kecepatan
		
		if ( (arah_kinematis < 0 && position.x > perpus.pos_kamera(true).x) ||
			(arah_kinematis > 0 && position.x < perpus.pos_kamera(true).x) ):
			mainkan_anim("Jatuh")
			if (is_on_floor()): kecepatan.y = -KECEPATAN_V * 2
			kecepatan.x = 0
		else:
			if (perpus.pos_kamera(true).x > position.x): ganti_arah(1)
			else: ganti_arah(-1)
			kecepatan.x = KECEPATAN_H * arah
			
		if (kecepatan.y >= 0):
			move_and_slide(gerakan, LANTAI_NORMAL, 0)
		else:
			move_and_slide(gerakan, ATAP_NORMAL, 0)
	pass
	
func mulai_nembak():
	perpus.mainkan_sfx("nembak")
	nembak = WAKTU_NEMBAK
	var nembak_obj = tembakanM.instance()
	if (lagi_manjat):
		nembak_obj.position.y = position.y - 2
		nembak_obj.position.x = position.x + 15 * arah
	else:
		nembak_obj.position.y = position.y + 3 if (is_on_floor()) else position.y - 5
		nembak_obj.position.x = position.x + 18 * arah if (is_on_floor()) else position.x + 13 * arah
	nembak_obj.arah = arah
	get_parent().add_child(nembak_obj)
	
func mulai_slide():
	selesai_licin()
	slide = WAKTU_SLIDE
	jalan = false
	arah_slide = arah
	ganti_coll("slide")
#	position.x -= 12 * arah
	var slide_obj = slideM.instance()
	slide_obj.position.y = position.y + 12
	slide_obj.position.x = position.x - 14 * arah_slide
	slide_obj.tampil(arah_slide)
	get_parent().add_child(slide_obj)

func selesai_slide(diem = true, paksa = false):
	if(test_move(transform, Vector2(0, -1)) && !paksa):
		ganti_coll("slide")
		slide = 1
	else:
		ganti_coll("biasa")
		slide = 0
		kecepatan.x = 0
		$Sprite.position.y = 0
		if (diem): mainkan_anim("Diem");

func transisi_kamera(stat):
	if (waktu_kena <= 0):
		bisa_bergerak = !stat
	if (stat):
		kecepatan_tersimpan[1] = kecepatan.y
		kecepatan.y = 0
		kecepatan.x = 0
		gravitasi = 0
	else:
		kecepatan.y = kecepatan_tersimpan[1]
		gravitasi = perpus.GRAVITASI_AIR if di_air == "masuk" else perpus.GRAVITASI
		
	pass
	
func mati():
	if (mati == 0 && waktu_sakit == 0):
		mati = 1
		selesai_licin()
		slide = 0
		selesai_slide(false, true)
		waktu_sakit = 0
		waktu_kena = 0
		lagi_manjat = false
		kontrol_anim("lanjut")
		$Sprite.visible = false
		$CollBiasa.disabled = true
		perpus.mainkan_musik("stop")
		perpus.mainkan_sfx("mati")
		waktu_mati = perpus.WAKTU_MATI
		for i in 16:
			var mati_obj = matiM.instance()
			mati_obj.global_position = Vector2(0, 0)
			mati_obj.tampil(i)
			add_child(mati_obj)

func mainkan_anim(anim):
	if (status_anim != anim):
		status_anim = anim
		$AnimationPlayer.play(status_anim)

func kontrol_anim(stat):
	match (stat):
		"Jeda": $AnimationPlayer.playback_speed = 0
		"Lanjut": $AnimationPlayer.playback_speed = 1
		
func ganti_arah(arah_arg):
	arah = arah_arg
	if (arah < 0): $Sprite.set_flip_h(true)
	else: $Sprite.set_flip_h(false)
		
func _input(event):
	
	if (Input.is_key_pressed(KEY_D) && mati == 0): mati()
		
	if (event.is_action_released("kanan") || event.is_action_released("kiri")):
		if (jalan): 
			jalan = false
			kecepatan.x = 0
	pass
	
func kena(darah = 0):
	if (waktu_sakit <= 0):
		hp -= darah
		if (hp <= 0):
			hp = 0
		darahMeterM.set_darah(hp)
		if (hp == 0):
			mati()
			return
		lagi_manjat = false
		darahMeterM.set_darah(hp)
		perpus.mainkan_sfx("kena")
		waktu_sakit = WAKTU_SAKIT
		waktu_kena = WAKTU_KENA
		mainkan_anim("Kena")
		bisa_bergerak = false
		kecepatan.y = 300
	pass
	
func set_status_air(status):
	di_air = status
	gravitasi = perpus.GRAVITASI_AIR if status == "masuk" else perpus.GRAVITASI
	perpus.mainkan_sfx("air")
	var air_obj = airM.instance()
	air_obj.tampil(0)
	air_obj.position.x = position.x
	if (status == "masuk"):
		air_obj.position.y = ceil(position.y / 16) * 16
	else:
		air_obj.position.y = ceil((position.y + 16) / 16) * 16
	get_parent().add_child(air_obj)
	pass
	
func reset():
	hp = 28
	kamera.get_node("AreaKamera/CollisionShape2D").disabled = true
	darahMeterM.set_darah(hp)
	$Sprite.visible = true
	mainkan_anim("Ready")
	position = kamera.position
	waktu_status = WAKTU_MULAI
	ganti_arah(1)
	for i in get_children():
		if "Partikel Mati" in i.name: i.queue_free()
	
func tangga_atas(arg, obj):
	tangga_atas = arg
	tangga_atas_obj = obj
	pass
	
func ganti_coll (coll):
	if (coll == "slide"):
		$CollBiasa.position = Vector2(0, 8.5)
		$CollBiasa.shape.extents = Vector2(10, 7.5)
	elif (coll == "biasa"):
		$CollBiasa.position = Vector2(0, 2)
		$CollBiasa.shape.extents = Vector2(7, 14)
	pass
	
func persiapan_kinematis():
	waktu_tgg_kinematis = WAKTU_TUNGGU_KINEMATIS
	pass
	
func status_animasi(status):
	$AnimationPlayer.playback_speed = 0 if (status == "diam") else 1
	
func selesai_licin() :
	licin_var = 0
	kecepatan.x = 0
	arah_terakhir = 0

func _on_animasi_selesai( anim_name ):
	if (anim_name == "Teleportasi_Mulai"):
		status_megageblek = "mulai normal"
	pass # replace with function body
