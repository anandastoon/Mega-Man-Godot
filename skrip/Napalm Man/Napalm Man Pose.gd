extends Area2D

var level
var darah_meter
var megaman
var status = "turun"

const DARAH_METER_DELAY = 3
var konter_delay = 0
var darah = 0
onready var napalm_man = preload("res://objek/Napalm Man/Napalm Man.tscn")

func _ready():
	level = get_node("/root/Level")
	level.get_node("Bgm").stop()
	level.get_node("Bgm Raja").play()
	darah_meter = level.get_node("Camera2D/Darah Meter Raja")
	megaman.ganti_arah(1)
	megaman.bisa_kontrol = false
	megaman.kecepatan.x = 0
	position.y = perpus.pos_kamera().y - 24
	position.x = perpus.pos_kamera().x + 210
	$AnimationPlayer.play("Diam")
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if (status == "turun"):
		position.y += 2
		if (position.y > perpus.pos_kamera().y + 12 * perpus.LEBAR_BLOK - 2):
			status = "pose"
	
	if (status == "pose"):
		yield(get_tree().create_timer(0.15), "timeout")
		$AnimationPlayer.play("Intro")
		$AnimationPlayer.playback_speed = 0.8
		status = "posekelar"
		
	if (status == "munculdarah"):
		darah_meter.show()
		darah_meter.get_node("AnimationPlayer").play("Darah")
		darah_meter.get_node("AnimationPlayer").playback_speed = 0
		status = "isidarah"
		darah_meter.set_darah(0)
		
	if (status == "isidarah"):
		konter_delay += 1
		konter_delay %= DARAH_METER_DELAY
		if (konter_delay == 0):
			perpus.mainkan_sfx("energi")
			darah += 1
			darah_meter.get_node("AnimationPlayer").seek(darah * 0.1, true)
			if (darah == perpus.MAKS_DARAH):
				status = "selesai"
				megaman.bisa_bergerak = true
				megaman.bisa_kontrol = true
		
	if (status == "selesai"):
		var napalm_man_obj = napalm_man.instance()
		napalm_man_obj.position = position
		napalm_man_obj.level = level
		napalm_man_obj.darah_meter = darah_meter
		napalm_man_obj.megaman = megaman
		level.add_child(napalm_man_obj)
		queue_free()
	pass


func _on_AnimationPlayer_animation_finished( anim_name ):
	if (anim_name == "Intro"):
		status = "munculdarah"
		$AnimationPlayer.play("Diam")
		
	pass # replace with function body
