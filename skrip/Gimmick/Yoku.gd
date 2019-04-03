extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$AnimationPlayer.play("Yoku")
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if (perpus.transisi): queue_free()
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass


func _on_AnimationPlayer_animation_finished( anim_name ):
	queue_free()
	pass # replace with function body
