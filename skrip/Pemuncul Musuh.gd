extends Node2D

export (String) var indeks = "Nama Musuh Di sini"
export (int) var arg = 0
onready var level = get_parent()
onready var stak_musuh = level.get_node("StakMusuh")

var aktif = false
var megaman
var objek
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	hide()
	megaman = get_parent().get_node("Megaman")
	match (indeks):
		"Laser":
			objek = load("res://objek/Gimmick/Laser Muncul.tscn")
		"Lirik":
			objek = load("res://objek/Musuh/Lirik.tscn")
		"Yoku":
			objek = load("res://objek/Gimmick/Yoku Muncul.tscn")
		"Platform Bunga":
			objek = load("res://objek/Gimmick/Platform Bunga.tscn")
		"Raja":
			objek = load("res://objek/Napalm Man/Napalm Man Pose.tscn")
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if (aktif && megaman.status_megageblek == "normal" && !perpus.transisi && !perpus.pintu_raja):
		var objekM
		objekM = objek.instance()
		objekM.set_meta("induk", name)
		objekM.megaman = megaman
		if (objekM.get("indeks") != null): objekM.indeks = arg
		objekM.position = position
		stak_musuh.add_child(objekM)
		aktif = false
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass

func _on_VisibilityNotifier2D_viewport_entered( viewport ):
	pass # replace with function body


func _on_area_entered( area ):
	if (area.name == "AreaKamera"):
		for i in stak_musuh.get_children():
			if (i.get_meta("induk") == name):
				return
		aktif = true
		set_process(true)
	pass # replace with function body


func _on_area_exited( area ):
	set_process(false)
	pass # replace with function body
