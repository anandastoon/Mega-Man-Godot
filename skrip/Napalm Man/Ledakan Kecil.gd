extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var direksi = Vector2(0, 0)
var tipe_serang = 0
var idks = 0
var sudut_dir = 0.0
var kecepatan = 4

func tampil():
	$AnimationPlayer.play("Anim")
	pass

func _process(delta):
	if (tipe_serang == 1):
		direksi = Vector2(cos(deg2rad(sudut_dir)), sin(deg2rad(sudut_dir)))
		position += direksi * kecepatan
	
	if (overlaps_body(perpus.megaman)):
		perpus.megaman.kena(2)
	pass


func _on_Ledakan_Kecil_area_exited( area ):
	match area.name:
		"AreaKamera":
			queue_free()
	pass # replace with function body
