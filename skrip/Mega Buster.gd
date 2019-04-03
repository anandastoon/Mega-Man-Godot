extends Area2D

var arah = 0 #-1: Kiri 1: Kanan
var repel = false

func _ready():
	set_meta("jenis", "senjata")
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if (repel):
		position.y -= perpus.kec_tembakan[0] + 2
		position.x += (perpus.kec_tembakan[0] + 2) * arah
	else:
		position.x += perpus.kec_tembakan[0] * arah * delta * Engine.get_frames_per_second()
		if (arah < 0): $Sprite.set_flip_h(true)
	
	if (perpus.transisi): queue_free()
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass

func repel():
	repel = true
	arah *= -1
	perpus.mainkan_sfx("tit")
	$Sprite.set_flip_h(true)

func _on_area_exited( area ):
	match area.name:
		"AreaKamera":
			queue_free()
	pass # replace with function body
