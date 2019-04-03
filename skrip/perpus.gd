extends Node2D

const TARGET_FPS = 60
const GRAVITASI = 980
const GRAVITASI_AIR = 400
const WAKTU_MATI = 170
const LEBAR_BLOK = 16
const MAKS_DARAH = 28
var kec_tembakan = [6]
var aspek_zoom = 2
var FLASH_MUSUH = 5
var lebar_layar
var transisi = false
var pintu_raja = false
var kec_transisi = 4
var kec_mm_transisi = 0.25
var kec_mm_transisi_pintu_raja = 0.72
var lebar_asli_layar = 256
var setengah_layar = lebar_asli_layar / 2
var level = "Napalm"
var kamera_obj

var level_json
var laser_data
var yoku_data

var nama_kamera = "AreaKamera"
var nama_megaman = "Megaman"
var megaman

#Suara
var prior_kini = 0
onready var sfx_node = get_parent().get_node("Level/Sfx")
onready var bgm_node = get_parent().get_node("Level/Bgm")
onready var partikel_mati = preload("res://objek/Musuh/Partikel Mati Musuh.tscn")

var sfx_data = {
		"air": 8,
		"telepor": 8,
		"ledak2": 8,
		"nembak": 7,
		"yoku": 8,
		"mendarat": 7,
		"laser": 9,
		"musuh_kena": 8,
		"pintu": 8,
		"kena": 8,
		"energi": 8,
		"musuh_mati": 8,
		"tit": 8,
		"tembyut": 8,
		"nyawa": 8,
		"mati": 10
	}

func _ready():
	kamera_obj = get_tree().get_root().get_node("Level/Camera2D")
	Engine.target_fps = TARGET_FPS
	lebar_layar = get_viewport().size.x

	# Level Data
	var file = File.new()
	file.open("res://Level/level1.json", file.READ)
	var text = file.get_as_text()
	level_json = parse_json(text)
	file.close()
	
	# Laser Data
	file = File.new()
	file.open("res://Level/laser.json", file.READ)
	text = file.get_as_text()
	laser_data = parse_json(text)
	file.close()
	
	# Yoku Data
	file = File.new()
	file.open("res://Level/yoku.json", file.READ)
	text = file.get_as_text()
	yoku_data = parse_json(text)
	file.close()
	pass

func ambil_laser_data() :
	pass

func ambil_level_data(level) :
	return level_json[str(level)]
	
func mainkan_musik(status):
	if (status == "play"): bgm_node.play()
	else: bgm_node.stop()
	
	
func mainkan_sfx(sfx):
	if (prior_kini > sfx_data[sfx]):
		if (!sfx_node.playing):
			sfx_node.stream = load("res://suara/" + sfx + ".wav")
			sfx_node.play()
			prior_kini = sfx_data[sfx]
	else:
		sfx_node.stream = load("res://suara/" + sfx + ".wav")
		sfx_node.play()
		prior_kini = sfx_data[sfx]

	pass
	
func dapatkan_fps():
	pass
	
func pos_kamera(ditengah = false):
	var ix = kamera_obj.position.x
	var iy = kamera_obj.position.y
	if (!ditengah):
		ix -= setengah_layar
		iy -= setengah_layar
	return Vector2(ix, iy)
	pass
	
func boundary_layar():
	var ix = floor(kamera_obj.position.x / lebar_asli_layar) * lebar_asli_layar
	var iy = floor(kamera_obj.position.y / lebar_asli_layar) * lebar_asli_layar
	return Vector2(ix, iy)
	pass

func kalkulasi_lompat_jarak(jarakA, jarakB):
	
	pass