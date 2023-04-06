extends Node3D

var menu_principale = preload("res://menu/menu.tscn")
var note = preload("res://note/Note.tscn")
var piste = preload("res://piste/plateau.tscn")
var option = preload("res://menu/option.tscn")
var colors=[preload("res://couleur/green.tres"),preload("res://couleur/red.tres"),preload("res://couleur/yellow.tres"),preload("res://couleur/blue.tres"),preload("res://couleur/orange.tres")]
var dificulty=preload("res://menu/dificulty.tscn")
var command=preload("res://menu/command.tscn")

var notes=[]
var instance
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
var fi1=true
var fi2=true
var fi3=true
var fi4=true
var entry=0
signal click(index)

signal all_note(notes)

# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.set_default_clear_color(Color.DODGER_BLUE)
	instance = menu_principale.instantiate()
	add_child(instance)
	$menu.connect("param", Callable(self, "choix"))
	pass # Replace with function body.

func choix(entrer):
	match entrer:
		1:
			entry=1
			play=true
			instance.queue_free()
			print("jouer")
			var sfx = load("res://son/PunchDeck_ICantStop.mp3") 
			sfx.set_loop(false)
			$Player.stream=sfx
			plat = piste.instantiate()
			add_child(plat)
			tchlist=$plateau.get("tchlist")
			$plateau.connect("update", Callable(self, "upd"))
			var pos
			var newpos=0.59
			if nbrtouche%2==1:
				pos=-((nbrtouche-1)/2)*0.6
			else:
				pos=-0.9
			var l=int($Player.stream.get_length())
			var buf=$Player.stream.data
			var sample=buf.size()/(l*2)
			var ma=0
			for i in l*2:
				ma+=buf[i*sample]
			var moy=ma/(l*2)
			for n in l*2:
				var x=0
				for j in nbrtouche:
					if (moy/nbrtouche)*2*j<buf[n*sample]:
						x=j
				if buf[n*sample]!=0:
					instance =note.instantiate()
					instance.position.z=-(5+n*5)
					instance.position.x=pos+x*newpos
					instance.get_node("MeshInstance").material_override = colors[x]
					add_child(instance)
					notes.append([instance,x])
			emit_signal("all_note",notes)
			$Player.play()
			$Timer.wait_time=0.01
			$Timer.start()
			$Timer2.wait_time=0.02
			$Timer2.start()
			$Timer3.wait_time=0.03
			$Timer3.start()
			$Timer4.wait_time=0.04
			$Timer4.start()
			$Timer5.start()
		2:
			entry=2
			instance.queue_free()
			print("option")
			instance=option.instantiate()
			add_child(instance)
			$Option.connect("param", Callable(self, "choix"))
		3:
			entry=3
			instance.queue_free()
			print("commande")
			instance=command.instantiate()
			add_child(instance)
			$Command.connect("com", Callable(self, "chcom"))
			$Command.connect("param", Callable(self, "choix"))
		4:
			entry=4
			instance.queue_free()
			print("dificulty")
			instance=dificulty.instantiate()
			add_child(instance)
			$Dificulty.connect("touche", Callable(self, "chtouche"))
			$Dificulty.connect("param", Callable(self, "choix"))
		5:
			entry=1
			instance.queue_free()
			print("return")
			instance=menu_principale.instantiate()
			add_child(instance)
			$menu.connect("param", Callable(self, "choix"))
			
		6:
			entry=6
			instance.queue_free()
			print("option")
			instance=option.instantiate()
			add_child(instance)
			$Option.connect("param", Callable(self, "choix"))


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
				var list=PackedByteArray([event.keycode])
				var but=list.get_string_from_ascii()
				var verif=false
				var index=-1
				for i in range(0,nbrtouche):
					if touches[i]==but:
						verif=true
						index=i
				if verif:
					var add=true
					for y in tchapp:
						if y[0]==index:
							add=false
					if add:
						emit_signal("click",index)
						tchapp.append([index,10])
func _input(event):
	if event.is_action_pressed("echap"):
		if entry ==6 or entry==2:
			entry=5
			choix(entry)
		if entry ==4 or entry==3:
			entry=2
			choix(entry)

func _process(_delta):
	for i in tchlist:
		i.get_node("appuie").position.y=0.1
	var index=0
	for i in range(0,tchapp.size()):
		if tchapp[i-index][1]==0:
			tchapp.remove_at(i-index)
			index+=1
		else:
			tchlist[tchapp[i-index][0]].get_node("appuie").position.y=0
			tchapp[i-index][1]-=1

func upd(index):
	notes.remove_at(index)


func _on_Timer_timeout():
	if fi1:
		$Timer.wait_time=0.05
		fi1=false
	for i in notes:
		i[0].position.z+=0.1
	pass



func _on_timer_2_timeout():
	if fi2:
		$Timer2.wait_time=0.05
		fi2=false
	for i in notes:
		i[0].position.z+=0.1
	pass # Replace with function body.


func _on_timer_3_timeout():
	if fi3:
		$Timer3.wait_time=0.05
		fi3=false
	for i in notes:
		i[0].position.z+=0.1
	pass # Replace with function body.


func _on_timer_4_timeout():
	if fi4:
		$Timer4.wait_time=0.05
		fi4=false
	for i in notes:
		i[0].position.z+=0.1
	pass # Replace with function body.


func _on_timer_5_timeout():
	for i in notes:
		i[0].position.z+=0.1
	pass # Replace with function body.
