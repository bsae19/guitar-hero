extends Node3D

var color=preload("res://couleur/black.tres")
var format=[".mp3"]
var actuel=null
# Called when the node enters the scene tree for the first time.
func _ready():
	var files = []
	var dir=DirAccess.open("res://son")
	if dir:
		dir.list_dir_begin()
		var file_name=dir.get_next()
		var x=0
		while file_name !="":
			if !dir.current_is_dir():
				for i in format:
					if file_name.ends_with(i):
						var file2=[]
						file2.append(file_name)
						var info=file_name.split(i)
						file2.append(info[0])
						files.append(file2)
						var body=StaticBody3D.new()
						body.position.y=x
						x-=1
						add_child(body)
						var morceau = MeshInstance3D.new()
						var rec=BoxMesh.new()
						rec.size.x=1.5
						rec.size.y=0.5
						rec.size.z=0.2
						rec.material=color
						morceau.mesh=rec
						morceau.position.x=-1.4
						morceau.position.y=1.6
						morceau.scale.x=1.3
						body.add_child(morceau)
						var coli=CollisionShape3D.new()
						var shape=BoxShape3D.new()
						shape.size.x=0.976
						shape.size.y=0.25
						shape.size.z=0.1
						shape.margin=0.04
						coli.shape=shape
						coli.position.x=-1.4
						coli.position.y=1.6
						body.add_child(coli)
						body.connect("mouse_entered",Callable(self, "_on_StaticBody3D_mouse_entered"))
						#body.connect("mouse_exited",Callable(self, "_on_StaticBody3D_mouse_exited"))
				file_name=dir.get_next()
	print(files)


func _on_StaticBody3D_mouse_entered():
	var listen=get_signal_connection_list("mouse_entered")
	print(listen.size())
#Titre:  Overthinking
#Auteur: RYYZN
#Source: https://soundcloud.com/ryyzn
#Licence: https://creativecommons.org/licenses/by/3.0/deed.fr

#Titre:  I Can't Stop
#Auteur: Punch Deck
#Source: https://soundcloud.com/punch-deck
#Licence: https://creativecommons.org/licenses/by/4.0/deed.fr

func _process(_delta):
	pass

