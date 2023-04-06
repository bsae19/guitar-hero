extends Node3D

var format=[".mp3"]
# Called when the node enters the scene tree for the first time.
func _ready():
	var files = []
	var dir=DirAccess.open("res://son")
	if dir:
		dir.list_dir_begin()
		var file_name=dir.get_next()
		while file_name !="":
			if !dir.current_is_dir():
				for i in format:
					if file_name.ends_with(i):
						var file2=[]
						file2.append(file_name)
						var info=file_name.split(i)
						file2.append(info[0])
						files.append(file2)
				file_name=dir.get_next()
	print(files)
	pass

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
