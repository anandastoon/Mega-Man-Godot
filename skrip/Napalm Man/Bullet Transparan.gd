extends KinematicBody2D

const KECEPATAN_V = 500
const KECEPATAN_H = 10

var megaman
var arah = 1
var tipe_serang = 0
var kecepatan = Vector2(0,0)
var status = ""
onready var bullet_ledak = preload("res://objek/Napalm Man/Bullet Ledak.tscn")
onready var ledakan_kecil = preload("res://objek/Napalm Man/Ledakan Kecil.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	$AnimationPlayer.play("Anim")
	pass

func _process(delta):
	if (tipe_serang == 0):
		if (status == ""):
			kecepatan.y = -KECEPATAN_V;
			kecepatan.x = KECEPATAN_H * arah;
			status = "ok"
	
		if ($Area2D.overlaps_body(megaman) || is_on_floor()):
			var bullet_ledakM = bullet_ledak.instance()
			bullet_ledakM.position = global_position
			bullet_ledakM.tipe_serang = 0
			get_parent().add_child(bullet_ledakM)
			queue_free()
		pass
		
	if (tipe_serang == 1):
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
			
	kecepatan.y += perpus.GRAVITASI * delta
	move_and_slide(kecepatan, Vector2(0,-1))
	
