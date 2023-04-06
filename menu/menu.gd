extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal param(entrer)
var entrer=0
# Called when the node enters the scene tree for the first time.

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			match entrer:
				1,2:
					emit_signal("param",entrer)
				3:
					print("quitter")
					get_tree().quit()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var nbr=get_tree().get_root().get_node("jeu").get("nbrtouche")
	$Node3D/plateau.scale.x=1+(nbr-3)*0.25
	pass


func _on_StaticBody_mouse_entered():
	entrer=1


func _on_StaticBody_mouse_exited():
	entrer=0


func _on_StaticBody2_mouse_entered():
	entrer=2


func _on_StaticBody2_mouse_exited():
	entrer=0


func _on_StaticBody3_mouse_entered():
	entrer=3


func _on_StaticBody3_mouse_exited():
	entrer=0
