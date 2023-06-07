extends Node3D

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
var tp=[]
signal update(index)

func _process(_delta):
	for i in note_in:
		if i[2] and !feu[i[0][1]].is_playing():
			feu[i[0][1]].visible=true
			feu[i[0][1]].play()
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_root().get_node("jeu").connect("all_note", Callable(self, "add"))
	get_tree().get_root().get_node("jeu").connect("click", Callable(self, "verif"))
	get_tree().get_root().get_node("jeu").connect("click2", Callable(self, "verif2"))
	couleur=get_tree().get_root().get_node("jeu").get("colors")
	score=get_tree().get_root().get_node("jeu").get("score")
	multi=get_tree().get_root().get_node("jeu").get("multi")
	$Score.text="Score: "+ str(score)
	$Multi.text="x"+ str(multi)
	nbr=get_tree().get_root().get_node("jeu").get("nbrtouche")
	$Node3D/plateau.scale.x=1.0*nbr/3.0
	var pos=0
	var newpos=0.59
	if nbr%2==1:
		pos=-((nbr-1)/2)*0.6
	else:
		pos=-0.9
	for i in range(0,nbr):
		instance=anim.instantiate()
		instance.visible=false
		instance.position.x=pos+i*newpos
		instance.position.y=0.4
		instance.position.z=0.4
		add_child(instance)
		feu.append(instance)
	for i in range(0,nbr):
		instance = touche.instantiate()
		instance.position.x=pos+i*newpos
		instance.position.z=0.3
		instance.scale.x=0.8
		instance.scale.y=0.8
		instance.scale.z=0.8
		instance.get_node("colorcase").material_override = couleur[i]
		add_child(instance)
		tchlist.append(instance)
		instance.connect("note_enter", Callable(self, "enter"))
		instance.connect("note_exit", Callable(self, "exit"))
	for i in range(0,2):
		instance = base.instantiate()
		instance.scale.x=0.15+(nbr-3)*0.03
		instance.position.x=0.015+pos-(0.35+((nbr-3)*0.02))+(nbr*newpos+((nbr-3)*0.055)+0.095)*i
		instance.position.y=-0.01
		instance.position.z=0.2
		add_child(instance)
	pass # Replace with function body.

func add(no):
	notes=no

func enter(node):
	for i in range(0,notes.size()):
		if notes[i][0].get_node("StaticBody3D")==node:
			note_in.append([notes[i],true,false])

func exit(node):
	var index=-1
	var test=false
	for i in range(0,note_in.size()):
		if note_in[i][0][2]==0:
			if note_in[i][0][0].get_node("StaticBody3D")==node:
				index=i
				test=true
		else:
			if note_in[i][0][0].get_node("StaticBody3D")==node:
				note_in[i][1]=false
			if note_in[i][0][0].get_node("longeur").get_node("fil")==node:
				index=i
				test=true
				
	if test:
		note_in.remove_at(index)

func verif(index):
	var ind=-1
	var ind2=-1
	var test=false
	for i in range(0,note_in.size()):
		for y in range(0,notes.size()):
			if notes[y][0]==note_in[i][0][0]:
				if note_in[i][0][1]==index:
					ind=y
					ind2=i
					test=true
	if test:
		if note_in[ind2][0][2]==0:
			score+=5*multi
			if multi<8:
				multi+=1
			$Score.text="Score: "+ str(score)
			feu[index].visible=true
			feu[index].play()
			emit_signal("update",ind)
			note_in.remove_at(ind2)
			tp.append(1)
		else:
			if note_in[ind2][1]==true:
				feu[index].visible=true
				feu[index].play()
				note_in[ind2][2]=true
	$Multi.text="x"+str(multi)

func verif2(index):
	var ind=-1
	var ind2=-1
	var test=false
	for i in range(0,note_in.size()):
		for y in range(0,notes.size()):
			if notes[y][0]==note_in[i][0][0]:
				if note_in[i][0][1]==index and note_in[i][2]:
					ind=y
					ind2=i
					test=true
	if test:
		note_in[ind2][2]=false
		feu[note_in[ind2][0][1]].visible=false
		var scr=round(round(note_in[ind2][0][0].position.z-4.5)/5)
		score+=10*multi+scr*2*multi
		if multi<8:
			multi+=1
		$Score.text="Score: "+ str(score)
		emit_signal("update",ind)
		note_in.remove_at(ind2)
	else:
		if tp.size()==0:
			if multi>1:
				multi-=1
		else:
			tp.remove_at(0)
	$Multi.text="x"+str(multi)
