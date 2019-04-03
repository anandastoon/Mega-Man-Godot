extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Area2D_body_entered( body ):
	if (body.name == "Megaman"):
		body.posisi_tangga = position.x
		body.tangga_atas(true, self)
	pass # replace with function body


func _on_Area2D_body_exited( body ):
	if (body.name == "Megaman"):
		body.tangga_atas(false, self)
	pass # replace with function body
