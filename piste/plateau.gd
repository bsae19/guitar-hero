extends Spatial

var touche = preload("res://piste/touche.tscn")
var base = preload("res://piste/base.tscn")
var anim = preload("res://piste/flamme.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var instance
var nbr
var couleur
var tchlist =[]
var notes =[]
var note_in=[]
var feu=[]
var score=0
var multi=1
signal update(index)
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().get_node("jeu").connect("all_note", self, "add")
	get_tree().get_root().get_node("jeu").connect("click", self, "verif")
	couleur=get_tree().get_root().get_node("jeu").get("colors")
	nbr=get_tree().get_root().get_node("jeu").get("nbrtouche")
	$Spatial/plateau.scale.x=1.0*nbr/3.0
	var pos=0
	var newpos=0.5
	if nbr%2==1:
		pos=-((nbr-1)/2)*0.5
	else:
		pos=-0.75
	for i in range(0,nbr):
		instance=anim.instance()
		instance.visible=false
		instance.translation.x=pos+i*newpos
		instance.translation.y=0.4
		instance.translation.z=0.4
		add_child(instance)
		feu.append(instance)
	for i in range(0,nbr):
		var instance = touche.instance()
		instance.translation.x=pos+i*newpos
		instance.translation.z=0.3
		instance.scale.x=0.8
		instance.scale.y=0.8
		instance.scale.z=0.8
		instance.get_node("colorcase").material_override = couleur[i]
		add_child(instance)
		tchlist.append(instance)
		instance.connect("note_enter",self,"enter")
		instance.connect("note_exit",self,"exit")
	for i in range(0,2):
		var instance = base.instance()
		instance.scale.x=0.15+(nbr-3)*0.03
		instance.translation.x=pos-(0.35+((nbr-3)*0.06))+(nbr*newpos+((nbr-3)*0.12)+0.2)*i
		instance.translation.y=-0.01
		instance.translation.z=0.2
		add_child(instance)
	pass # Replace with function body.

func add(no):
	notes=no

func enter(node):
	for i in range(0,notes.size()):
		if notes[i][0].get_node("StaticBody")==node:
			note_in.append([notes[i],i])

func exit(node):
	var index=-1
	var test=false
	for i in range(0,note_in.size()):
		if note_in[i][0][0].get_node("StaticBody")==node:
			index=i
			test=true
	if test:
		note_in.remove(index)

func verif(index):
	var ind=-1
	var test=false
	for i in range(0,note_in.size()):
		if note_in[i][0][1]==index:
			ind=i
			test=true
	if test:
		score+=10*multi
		if multi<8:
			multi+=1
		$Score.text="Score: "+ str(score)
		feu[note_in[ind][0][1]].visible=true
		feu[note_in[ind][0][1]].play()
		note_in[ind][0][0].queue_free()
		emit_signal("update",note_in[ind][1])
		note_in.remove(ind)
	else:
		if multi>1:
			multi-=1
	$Multi.text="x"+ str(multi)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
