extends Area2D

onready var megaman = preload("res://objek/Mega Man/Megaman.tscn")
# Yknow? Godot nggak bisa konek antara kinematic2D sama area.
# Makanya, ini 1 skrip buat handle macem2 objek yang tabrakan sama si Geblek
# ... atau objek lain

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass


func _on_area_entered( area ):
	print(area)
	pass # replace with function body


func _on_body_entered( body ):
	match (body.get_name()):
		"Megaman":
			if ("Kematian" in name): body.call("mati")
			if ("Tangga" in name): 
				body.di_tangga = true
				body.posisi_tangga = position.x
			if ("Air" in name): 
				body.set_status_air("masuk")
	pass # replace with function body


func _on_body_exited( body ):
	match (body.get_name()):
		"Megaman":
			if ("Tangga" in name): body.di_tangga = false
			if ("Air" in name): 
				body.set_status_air("keluar")
	pass # replace with function body
