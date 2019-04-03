extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const WAKTU_MULAI_YOKU = 30
const WAKTU_YOKU = 60
var indeks = 0
var megaman
# Properti lazahz
var jml = 0
var waktu = 9
var sekuens = []
var pos_sekuens = 0
var pos_waktu = []
var idx = 0
var banyak_idx
var yokuobj
onready var yoku = preload("res://objek/Gimmick/Yoku.tscn")

func _ready():
	waktu = WAKTU_MULAI_YOKU
	sekuens = perpus.yoku_data['sekuens'][0][indeks].split("*")
	pos_waktu = perpus.yoku_data['waktu'][0][indeks].split("*")

	banyak_idx = sekuens.size()
	
func _process(delta):
	
	if (perpus.transisi): queue_free()
	
	if (waktu > 0): waktu -= 1
	else:		
		
		if (idx == 0): pos_sekuens = 0
		pos_sekuens += int(sekuens[idx])
		
		for i in int(sekuens[idx]):
			yokuobj = yoku.instance()
			yokuobj.position.x = perpus.boundary_layar().x + perpus.yoku_data['x'][0][pos_sekuens - int(sekuens[idx]) + i] * perpus.LEBAR_BLOK
			yokuobj.position.y = perpus.boundary_layar().y + perpus.yoku_data['y'][0][pos_sekuens - int(sekuens[idx]) + i] * perpus.LEBAR_BLOK
			get_parent().add_child(yokuobj)
		
		if (idx + 1 == banyak_idx):
			waktu = WAKTU_YOKU * 2
		else:
			waktu = WAKTU_YOKU

		if (pos_waktu[idx] != "0"): waktu = int(pos_waktu[idx])

		idx += 1
		idx %= banyak_idx
		perpus.mainkan_sfx("yoku")

	pass
