extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const WAKTU_TETAP = 5
var indeks = 0
var opasitas = [0, 0.25, 0.5, 0.75, 1, 0.75, 0.5, 0.25]
var waktu = 0
var lasertile1
var lasertile2

func _ready():
	lasertile1 = get_parent().get_node("laserbattle_1")
	lasertile2 = get_parent().get_node("laserbattle_2")
	pass

func _process(delta):
	if (waktu > WAKTU_TETAP):
		waktu = 0
		modulate = Color(0, 0, 0, opasitas[indeks])
		indeks += 1
		indeks %= opasitas.size()
		if (indeks == 5):
			if (lasertile1.visible):
				lasertile1.visible = false
				lasertile2.visible = true
			else:
				lasertile2.visible = false
				lasertile1.visible = true
	else:
		waktu += 1
	pass
