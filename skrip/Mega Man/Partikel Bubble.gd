extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	$AnimatedSprite.play("Bubble")
	pass

func _process(delta):
	position.y -= 1
	pass


func _on_Partikel_Bubble_area_exited( area ):
	if (area.name == "Air" || area.name == "AreaKamera"):
		queue_free()
	pass # replace with function body
