extends Spatial

var menu_principale = preload("res://menu/menu.tscn")
var note = preload("res://note/Note.tscn")
var piste = preload("res://piste/plateau.tscn")
var option = preload("res://menu/option.tscn")
var colors=[preload("res://couleur/green.tres"),preload("res://couleur/red.tres"),preload("res://couleur/yellow.tres"),preload("res://couleur/blue.tres"),preload("res://couleur/orange.tres")]
var dificulty=preload("res://menu/dificulty.tscn")
var command=preload("res://menu/command.tscn")

var notes=[]
var instance
var spectrum
var w=500
var h=120
var mindb=60
var vu=16.0
var frm=12000.0
var plat
var tchlist=[]
var play =false
var nbrtouche=3
var touches=["A","Z","E","R","T"]
var tchapp=[]
signal click(index)

signal all_note(notes)

# Called when the node enters the scene tree for the first time.
func _ready():
	instance = menu_principale.instance()
	add_child(instance)
	$menu.connect("param", self, "choix")
	pass # Replace with function body.

func choix(entrer):
	match entrer:
		1:
			play=true
			instance.queue_free()
			print("jouer")
			var sfx = load("res://son/ambient.mp3") 
			sfx.set_loop(false)
			$Player.stream=sfx
			$Player.play()
			plat = piste.instance()
			add_child(plat)
			tchlist=$plateau.get("tchlist")
			$plateau.connect("update", self, "upd")
			var pos
			var newpos=0.5
			if nbrtouche%2==1:
				pos=-((nbrtouche-1)/2)*0.5
			else:
				pos=-0.75
			for n in 400:
				instance =note.instance()
				instance.translation.z=-(8+n*8)
				var x=randi() % nbrtouche
				instance.translation.x=pos+x*newpos
				instance.get_node("MeshInstance").material_override = colors[x]
				add_child(instance)
				notes.append([instance,x])
			emit_signal("all_note",notes)
		2:
			instance.queue_free()
			print("option")
			instance=option.instance()
			add_child(instance)
			$Option.connect("param", self, "choix")
		3:
			instance.queue_free()
			print("commande")
			instance=command.instance()
			add_child(instance)
			$Command.connect("com", self, "chcom")
			$Command.connect("param", self, "choix")
		4:
			instance.queue_free()
			print("dificulty")
			instance=dificulty.instance()
			add_child(instance)
			$Dificulty.connect("touche", self, "chtouche")
			$Dificulty.connect("param", self, "choix")
		5:
			instance.queue_free()
			print("return")
			instance=menu_principale.instance()
			add_child(instance)
			$menu.connect("param", self, "choix")
			
		6:
			instance.queue_free()
			print("option")
			instance=option.instance()
			add_child(instance)
			$Option.connect("param", self, "choix")


func chtouche(nbr):
	nbrtouche=nbr
	
func chcom(actlist):
	touches=actlist
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _unhandled_input(event):
	if play:
		if event is InputEventKey:
			if event.pressed:
				var list=PoolByteArray([event.scancode])
				var but=list.get_string_from_ascii()
				var verif=false
				var index=-1
				for i in range(0,nbrtouche):
					if touches[i]==but:
						verif=true
						index=i
					i+=1
				if verif:
					var add=true
					for y in tchapp:
						if y[0]==index:
							add=false
					if add:
						emit_signal("click",index)
						tchapp.append([index,10])

func _on_Timer_timeout():
	for i in notes:
		i[0].translation.z+=0.1
	for i in tchlist:
		i.get_node("appuie").translation.y=0.1
	var index=0
	for i in range(0,tchapp.size()):
		if tchapp[i-index][1]==0:
			tchapp.remove(i-index)
			index+=1
		else:
			tchlist[tchapp[i-index][0]].get_node("appuie").translation.y=0
			tchapp[i-index][1]-=1
func upd(index):
	notes.remove(index)
		
		
