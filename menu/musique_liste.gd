extends Node3D

signal jeu(ent)
var fon=preload("res://font/Angellya.ttf")
var ent=0
var color=preload("res://couleur/black.tres")
var format=[".mp3"]
var actuel=null
var files = []
# Called when the node enters the scene tree for the first time.
func _ready():
	var dir=DirAccess.open("res://son")
	if dir:
		dir.list_dir_begin()
		var file_name=dir.get_next()
		var x=0
		while file_name !="":
			if !dir.current_is_dir():
				for i in format:
					if file_name.ends_with(i):
						var info=file_name.split(i)
						var f=info[0].split("_")
						files.append(file_name)
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
						morceau.position.x=0
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
						coli.position.x=0
						coli.position.y=1.6
						body.add_child(coli)
						var t=Label3D.new()
						t.pixel_size=0.0168
						t.text=f[1]
						t.font=fon
						t.font_size=17
						t.outline_size=12
						t.uppercase=true
						t.position.y=1.65
						t.position.z=0.11
						body.add_child(t)
						var t1=Label3D.new()
						t1.pixel_size=0.0168
						t1.text=f[0]
						t1.font_size=5
						t1.outline_size=0
						t1.uppercase=true
						t1.position.y=1.42
						t1.position.z=0.11
						t1.position.x=-0.6
						body.add_child(t1)
						var test=func():
							ent=abs(x)
						body.connect("mouse_entered",test)
						var test2=func():
							ent=0
						body.connect("mouse_exited",test2)
				file_name=dir.get_next()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if ent !=0:
				emit_signal("jeu",files[ent-1])
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if self.position.y<files.size()/1.5:
				self.position.y+=0.1
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if self.position.y>-files.size()/10.0:
				self.position.y-=0.1
func _process(_delta):
	pass

