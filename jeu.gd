extends Node3D

var menu_principale = preload("res://menu/menu.tscn")
var note = [preload("res://note/Note.tscn"),preload("res://note/Notelong.tscn")]
var piste = preload("res://piste/plateau.tscn")
var option = preload("res://menu/option.tscn")
var colors=[preload("res://couleur/green.tres"),preload("res://couleur/red.tres"),preload("res://couleur/yellow.tres"),preload("res://couleur/blue.tres"),preload("res://couleur/orange.tres")]
var dificulty=preload("res://menu/dificulty.tscn")
var command=preload("res://menu/command.tscn")
var musique=preload("res://menu/musique_liste.tscn")
var opt=preload("res://menu/pause.tscn")
var fin=preload("res://menu/fin.tscn")

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
var fi5=0
var entry=0
var muse
var pau
var score=0
var multi=1
var faute=0
var tempfin=0
var start=true
var bpm=2
signal click(index)
signal click2(index)

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
			instance.queue_free()
			print("musique_list")
			instance=musique.instantiate()
			add_child(instance)
			$musique_liste.connect("jeu",Callable(self,"jeu"))
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
		7:
			print("restart")
			pau.queue_free()
			for i in notes:
				i[0].queue_free()
			notes=[]
			fi1=true
			fi2=true
			fi3=true
			fi4=true
			$Player.stop()
			$Timer.stop()
			$Timer2.stop()
			$Timer3.stop()
			$Timer4.stop()
			$Timer5.stop()
			entry=1
			instance=null
			jeu(muse)
		8:
			print("home")
			pau.queue_free()
			for i in notes:
				i[0].queue_free()
			notes=[]
			fi1=true
			fi2=true
			fi3=true
			fi4=true
			$Player.stop()
			$Timer.stop()
			$Timer2.stop()
			$Timer3.stop()
			$Timer4.stop()
			$Timer5.stop()
			entry=1
			instance=menu_principale.instantiate()
			add_child(instance)
			$menu.connect("param", Callable(self, "choix"))
		9:
			pau.queue_free()
			plat = piste.instantiate()
			add_child(plat)
			tchlist=$plateau.get("tchlist")
			$plateau.connect("update", Callable(self, "upd"))
			for i in notes:
				i[0].visible=true
			emit_signal("all_note",notes)
			fi1=true
			fi2=true
			fi3=true
			fi4=true
			$Player.stream_paused=false
			$Timer.wait_time=0.01
			$Timer.start()
			$Timer2.wait_time=0.02
			$Timer2.start()
			$Timer3.wait_time=0.03
			$Timer3.start()
			$Timer4.wait_time=0.04
			$Timer4.start()
			$Timer5.start()
			play=true
		10:
			print(notes.size())
			score=get_tree().get_root().get_node("jeu/plateau").get("score")
			plat.queue_free()
			play=false
			for i in notes:
				i[0].queue_free()
			notes=[]
			fi1=true
			fi2=true
			fi3=true
			fi4=true
			$Player.stop()
			$Timer.stop()
			$Timer2.stop()
			$Timer3.stop()
			$Timer4.stop()
			$Timer5.stop()
			pau=fin.instantiate()
			add_child(pau)
			$fin/score.text=str(score)
			score=0
			var info=muse.split(".mp3")
			var f=info[0].split("_")
			$fin/musique.text=str(f[1])
			$fin/artiste.text=str(f[0])
			$fin/faute.text="notes failed: "+str(faute)+"%"
			pau.connect("param", Callable(self, "choix"))
func chtouche(nbr):
	nbrtouche=nbr
func chcom(actlist):
	touches=actlist
func _unhandled_input(event):
	if play:
		if event is InputEventKey:
			if event.pressed:
				if event.keycode == KEY_ESCAPE:
					multi=get_tree().get_root().get_node("jeu/plateau").get("multi")
					score=get_tree().get_root().get_node("jeu/plateau").get("score")
					pau=opt.instantiate()
					for i in notes:
						i[0].visible=false
					plat.queue_free()
					add_child(pau)
					$pause.connect("param", Callable(self, "choix"))
					$Player.stream_paused=true
					$Timer.stop()
					$Timer2.stop()
					$Timer3.stop()
					$Timer4.stop()
					$Timer5.stop()
					play=false
				else:
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
			else:
				var list=PackedByteArray([event.keycode])
				var but=list.get_string_from_ascii()
				var verif=false
				var index=-1
				for i in range(0,nbrtouche):
					if touches[i]==but:
						verif=true
						index=i
				if verif:
					emit_signal("click2",index)
func _input(event):
	if event.is_action_pressed("echap"):
		if entry ==6 or entry==2:
			entry=5
			choix(entry)
		if entry ==4 or entry==3:
			entry=2
			choix(entry)

func _process(_delta):
	var fov=$Camera3D.fov
	var viewport_size=$Camera3D.get_viewport().get_visible_rect().size
	$fond.position.z=-((viewport_size.y / 2.0) / tan(deg_to_rad(fov) / 2.0))
	viewport_size.x+=5
	viewport_size.y+=3
	$fond.mesh.size=viewport_size
	if play:
		if tempfin==50:
			faute=round(notes.size()*100.0/faute)
			choix(10)
		if !$Player.playing and !start:
			tempfin+=1
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
	emit_signal("all_note",notes)
	var a=notes[index]
	notes.remove_at(index)
	a[0].queue_free()
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
	if start:
		if fi5<20:
			fi5+=1
		else:
			$Player.play()
			start=false
	for i in notes:
		i[0].position.z+=0.1
	pass # Replace with function body.
func jeu(ent):
	start=true
	fi5=0
	tempfin=0
	muse=ent
	if(instance!=null):
		instance.queue_free()
	print("jouer")
	var sfx =load("res://son/"+str(ent))
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
	var sample=buf.size()/(l*bpm)
	var ma=0
	for i in l*bpm:
		ma+=buf[i*sample]
	var moy=ma/(l*bpm)
	var positions=[]
	for n in l*bpm:
		var x=[]
		for j in nbrtouche*2:
			if (moy/(nbrtouche*2))*2*j<buf[n*sample]:
				x=[j,n,0]
		if x!=[]:
			positions.append(x)
	var new_position=[]
	for i in positions:
		if i[0]%2==0:
			new_position.append([i[0]/2,i[1],0])
		else:
			new_position.append([i[0]/2,i[1],0])
			if i[0]/2+1>=nbrtouche:
				new_position.append([i[0]/2+1-nbrtouche,i[1],0])
			else:
				new_position.append([i[0]/2+1,i[1],0])
	positions=[]
	for i in range(0,new_position.size()):
		var comptt=1
		var pl=false
		var actupos=[]
		for y in range(i+1,new_position.size()):
			if new_position[i][0] == new_position[y][0] and new_position[i][1]+comptt == new_position[y][1] and new_position[y][2]!=-1:
				actupos.append(y)
				pl=true
				comptt+=1
		if pl and comptt>2:
			for y in actupos:
				new_position[y][2]=-1
			var next_pos=new_position[i]
			next_pos[2]=1
			next_pos.append(comptt-1)
			positions.append(next_pos)
		elif new_position[i][2]!=-1:
			positions.append(new_position[i])
	for i in positions:
		instance =note[i[2]].instantiate()
		instance.position.z=-(15+i[1]*(10/bpm))
		instance.position.x=pos+i[0]*newpos
		if(i[2]==1):
			instance.get_node("longeur").scale.y*=i[3]
			instance.get_node("longeur").position.z*=i[3]
		instance.get_node("MeshInstance").material_override = colors[i[0]]
		add_child(instance)
		notes.append([instance,i[0],i[2]])
	faute=notes.size()
	emit_signal("all_note",notes)
	play=true
	$Timer.wait_time=0.01
	$Timer.start()
	$Timer2.wait_time=0.02
	$Timer2.start()
	$Timer3.wait_time=0.03
	$Timer3.start()
	$Timer4.wait_time=0.04
	$Timer4.start()
	$Timer5.start()
	
#image background licence:"Designed by Freepik"
#website: "http://www.freepik.com"

#Titre:  Overthinking
#Auteur: RYYZN
#Source: https://soundcloud.com/ryyzn
#Licence: https://creativecommons.org/licenses/by/3.0/deed.fr

#Titre:  I Can't Stop
#Auteur: Punch Deck
#Source: https://soundcloud.com/punch-deck
#Licence: https://creativecommons.org/licenses/by/4.0/deed.fr

#Titre:  Start the Engine
#Auteur: lemonmusicstudio
#Music by lemonmusicstudio from Pixabay
