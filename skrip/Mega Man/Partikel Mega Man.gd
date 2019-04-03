extends Node2D

var nama_animasi = ""
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass
	
func tampil(arah):
	if (arah == -1):
		$Sprite.set_flip_h(true)
	match name:
		"Partikel Slide": nama_animasi = "Slide"
		"Partikel Air": nama_animasi = "Air"	
	$AnimationPlayer.play(nama_animasi)

func _process(delta):
	if (nama_animasi == ""): tampil(0)
	pass


func _on_AnimationPlayer_animation_finished( anim_name ):
	queue_free()
	pass # replace with function body
