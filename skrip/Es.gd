extends Area2D

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Es_body_entered( body ):
	if (body.name == "Megaman"):
		body.licin = true

func _on_Es_body_exited( body ):
	if (body.name == "Megaman"):
		body.licin = false
