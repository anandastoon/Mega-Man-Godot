extends Area2D

var tes = 0
var direksi = 0
var kecepatan = 0.23
var megaman
var kena = 0
var hp = 2
var risiko = 2

func _ready():
	set_meta("jenis", "musuh")
	$AnimationPlayer.play("Lirik")
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	direksi = (megaman.position - position).normalized()
	position += direksi * kecepatan
	
	if (perpus.transisi): queue_free()
	
	if (overlaps_body(megaman)):
		megaman.kena(risiko)
	
	if (kena > 0):
		kena -= 1
		if (kena == 0):
			$Sprite.show()
	pass


func _on_Lirik_area_entered( area ):
	if (area.get_meta("jenis") == "senjata"):
		musuh_kena()
		area.queue_free()
	pass # replace with function body

func _on_Lirik_area_exited( area ):
	if (area.name == "AreaKamera"):
		queue_free()
	pass # replace with function body
	
func musuh_kena():
	hp -= 1
	if (hp == 0):
		perpus.mainkan_sfx("musuh_mati")
		var partikel = perpus.partikel_mati.instance()
		partikel.tampil()
		partikel.position = position
		get_parent().add_child(partikel)
		queue_free()
	else:
		kena = perpus.FLASH_MUSUH
		perpus.mainkan_sfx("musuh_kena")
		$Sprite.hide()


func _on_Lirik_body_entered( body ):
	if (body.name == "Megaman"):
		body.kena(risiko)
