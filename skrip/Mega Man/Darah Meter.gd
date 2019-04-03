extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$AnimationPlayer.play("Darah")
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func _process(delta):
	pass
	
func set_darah(darah):
	$AnimationPlayer.seek(darah * 0.1, true)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
