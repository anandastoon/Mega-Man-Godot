extends Area2D

onready var level = get_parent()
var megaman

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func status_pintu(status):
	if (status == "buka"):
		perpus.pintu_raja = true
		perpus.mainkan_sfx("pintu")
		position.y -= 16
		yield(get_tree().create_timer(0.1), "timeout")
		position.y -= 16
		yield(get_tree().create_timer(0.1), "timeout")
		position.y -= 16
		yield(get_tree().create_timer(0.1), "timeout")
		position.y -= 16
		yield(get_tree().create_timer(0.1), "timeout")
		megaman.status_animasi("gerak")
		level.mulai_transisi_pintu_raja(self)
	else:
		perpus.mainkan_sfx("pintu")
		megaman.status_animasi("diam")
		megaman.bisa_bergerak = false
		position.y += 16
		yield(get_tree().create_timer(0.1), "timeout")
		position.y += 16
		yield(get_tree().create_timer(0.1), "timeout")
		position.y += 16
		yield(get_tree().create_timer(0.1), "timeout")
		position.y += 16
		yield(get_tree().create_timer(0.1), "timeout")
		megaman.status_animasi("gerak")
		megaman.transisi_kamera(false)
		perpus.pintu_raja = false		


func _on_Pintu_Raja_body_entered( body ):
	if (body.name == "Megaman"):
		megaman = body
		megaman.status_animasi("diam")
		status_pintu("buka")
		megaman.bisa_bergerak = false
	pass # replace with function body
