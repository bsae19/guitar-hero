extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var entrez = preload("res://menu/entrez.tscn")
signal com(actlist)
signal param(entrer)
var entrer=0
var ancienentrez=0
var actueltouche=0
var desactiver=false
var actlist
var instan
var ent=false
func _ready():
	actlist=get_tree().get_root().get_node("jeu").get("touches")
	for i in range(0,actlist.size()):
		get_node("StaticBody"+str(i+1)+"/label"+str(i+1)).text=str(actlist[i])
# Called when the node enters the scene tree for the first time.
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if !ent:
				match entrer:
					0:
						pass
					6:
						if !desactiver:
							emit_signal("com",actlist)
							emit_signal("param",entrer)
					_:
						ancienentrez=entrer
						ent=true
						instan=entrez.instance()
						add_child(instan)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed:
			if ent:
				desactiver=false
				for i in range(0,actlist.size()):
					get_node("StaticBody"+str(i+1)+"/label"+str(i+1)).modulate= Color(1,1,1)
				var list=PoolByteArray([event.scancode])
				actlist[entrer-1]=list.get_string_from_ascii()
				for i in range(0,actlist.size()):
					for y in range(0,actlist.size()):
						if i!=y and actlist[i]==actlist[y]:
							desactiver=true
							get_node("StaticBody"+str(i+1)+"/label"+str(i+1)).modulate= Color(1,0,0)
							get_node("StaticBody"+str(y+1)+"/label"+str(y+1)).modulate= Color(1,0,0)
				get_node("StaticBody"+str(ancienentrez)+"/label"+str(ancienentrez)).text=str(actlist[ancienentrez-1])
				ancienentrez=0
				ent=false
				instan.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StaticBody_mouse_entered():
	entrer=1
	pass # Replace with function body.


func _on_StaticBody_mouse_exited():
	entrer=0
	pass # Replace with function body.


func _on_StaticBody2_mouse_entered():
	entrer=2
	pass # Replace with function body.


func _on_StaticBody2_mouse_exited():
	entrer=0
	pass # Replace with function body.


func _on_StaticBody3_mouse_entered():
	entrer=3
	pass # Replace with function body.


func _on_StaticBody3_mouse_exited():
	entrer=0
	pass # Replace with function body.


func _on_StaticBody4_mouse_entered():
	entrer=4
	pass # Replace with function body.


func _on_StaticBody4_mouse_exited():
	entrer=0
	pass # Replace with function body.


func _on_StaticBody5_mouse_entered():
	entrer=5
	pass # Replace with function body.


func _on_StaticBody5_mouse_exited():
	entrer=0
	pass # Replace with function body.


func _on_StaticBody6_mouse_entered():
	entrer=6
	pass # Replace with function body.


func _on_StaticBody6_mouse_exited():
	entrer=0
	pass # Replace with function body.
