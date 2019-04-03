extends StaticBody2D

var megaman

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
		if (Input.is_action_pressed("lompat")):
			body.kecepatan.y = -600
		else:
			body.kecepatan.y = -270
		$AnimationPlayer.play("Tembyut")
		perpus.mainkan_sfx("tembyut")
	pass # replace with function body
