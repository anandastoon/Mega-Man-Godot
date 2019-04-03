extends StaticBody2D

var megaman
var state = "kuncup"

func _ready():
	$AnimationPlayer.play("Kuncup")
	$CollisionShape2D.disabled = true
	pass

func _process(delta):
	if (perpus.transisi): queue_free()
	pass


func _on_Area2D_area_entered( area ):
	if (area.get_meta("jenis") == "senjata") :
		area.queue_free()
		if (state == "kuncup"):
			state = "kembang"
			$AnimationPlayer.play("Kembang")
			$CollisionShape2D.disabled = false
			$Area2D.queue_free()
			position.y += 4
		pass
	pass # replace with function body


func _on_Area2D_area_exited( area ):
	pass # replace with function body
