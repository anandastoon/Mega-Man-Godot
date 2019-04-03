extends Node2D

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func tampil():
	$AnimatedSprite.play("Mati")
	pass

func _process(delta):
	pass


func _on_AnimatedSprite_animation_finished( anim_name ):
	queue_free()
	pass # replace with function body
