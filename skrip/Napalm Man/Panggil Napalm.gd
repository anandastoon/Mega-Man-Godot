extends Area2D

var bisa_dipanggil = false
var napalm_man

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	if (bisa_dipanggil && !perpus.transisi):
		napalm_man.setelah_ngamuk = true
		queue_free()
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass


func _on_Napalm_Man_area_entered(area):
	if (area.name == "AreaKamera"):
		bisa_dipanggil = true
		pass
	pass # replace with function body
