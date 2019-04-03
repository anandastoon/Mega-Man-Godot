extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var tipe_serang = 0
var status = "ok"
var bahaya = "true"

onready var ledakan_besar = preload("res://objek/Napalm Man/Ledakan Besar.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if (tipe_serang == 0 && status == "ok") :
		status = "serang"
		var objek = ledakan_besar.instance()
		objek.position = position
		if (!bahaya): objek.status = "nggak ok"
		get_parent().add_child(objek)
		queue_free()
	pass