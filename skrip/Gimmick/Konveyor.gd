extends StaticBody2D

export var mode = "kanan"
export (Texture) var konveyor_kanan
export (Texture) var konveyor_kiri

func _ready():
	$Sprite.texture = konveyor_kanan if mode == "kanan" else konveyor_kiri
	$AnimationPlayer.play("Konveyor")
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
