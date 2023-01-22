extends Spatial

var ligne = preload("res://piste/ligne.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var nbr
# Called when the node enters the scene tree for the first time.
func _ready():
	nbr=get_tree().get_root().get_node("jeu").get("nbrtouche")
	var mat = $plateau.get_surface_material(0)
	mat.set_shader_param("speed", Vector3(0, -0.3, 0))
	var instance
	var pos
	var newpos=0.5
	if nbr%2==1:
		pos=(-((nbr-1)/2)*0.5)+0.4
	else:
		pos=-0.35
	for i in range(0,nbr):
		instance =ligne.instance()
		instance.translation.x=pos+i*newpos
		add_child(instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




