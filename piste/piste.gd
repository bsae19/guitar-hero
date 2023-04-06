extends Node3D

var ligne = preload("res://piste/ligne.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var nbr
# Called when the node enters the scene tree for the first time.
func _ready():
	nbr=get_tree().get_root().get_node("jeu").get("nbrtouche")
	var instance
	var pos
	var newpos=0.59
	if nbr%2==1:
		pos=(-((nbr-1)/2)*0.6)+0.4
	else:
		pos=-0.5
	for i in range(0,nbr):
		instance =ligne.instantiate()
		instance.position.x=pos+i*newpos
		add_child(instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




