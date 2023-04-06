extends Node3D


# Declare member variables here. Examples:
# var a = 2
signal touche(nbr)
signal param(entrer)
var entrer=0
var nbr=0
var color=[preload("res://couleur/red.tres"),preload("res://couleur/black.tres")]
# Called when the node enters the scene tree for the first time.
func _ready():
	nbr=get_tree().get_root().get_node("jeu").get("nbrtouche")
	match nbr:
		3:
			self.get_node("StaticBody3D/MeshInstance3D").material_override = color[0]
		4:
			self.get_node("StaticBody2/MeshInstance3D").material_override = color[0]
		5:
			self.get_node("StaticBody4/MeshInstance3D").material_override = color[0]

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if entrer!=0:
				self.get_node("StaticBody3D/MeshInstance3D").material_override = color[1]
				self.get_node("StaticBody2/MeshInstance3D").material_override = color[1]
				self.get_node("StaticBody4/MeshInstance3D").material_override = color[1]
				match entrer:
					1:
						self.get_node("StaticBody3D/MeshInstance3D").material_override = color[0]
						nbr=3
					2:
						self.get_node("StaticBody2/MeshInstance3D").material_override = color[0]
						nbr=4
					3:
						self.get_node("StaticBody4/MeshInstance3D").material_override = color[0]
						nbr=5
					6:
						emit_signal("touche",nbr)
						emit_signal("param",entrer)
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


func _on_StaticBody4_mouse_entered():
	entrer=3
	pass # Replace with function body.


func _on_StaticBody4_mouse_exited():
	entrer=0
	pass # Replace with function body.


func _on_StaticBody3_mouse_entered():
	entrer=6
	pass # Replace with function body.


func _on_StaticBody3_mouse_exited():
	entrer=0
	pass # Replace with function body.
