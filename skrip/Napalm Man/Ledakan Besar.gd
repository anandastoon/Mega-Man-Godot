extends Area2D

var status = "ok"

func _ready():
	perpus.mainkan_sfx("ledak2")
	$AnimationPlayer.play("Anim")
	pass

func _process(delta):
	if (overlaps_body(perpus.megaman) && status == "ok"):
		perpus.megaman.kena(2)
	pass


func _on_AnimationPlayer_animation_finished( anim_name ):
	queue_free()
	pass # replace with function body
