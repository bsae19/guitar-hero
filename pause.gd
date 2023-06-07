extends Node3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var entrer=0
# Called when the node enters the scene tree for the first time.
signal param(entrer)
# Called when the node enters the scene tree for the first time.

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if entrer !=0:
				emit_signal("param",entrer)


func _on_static_body_3d_mouse_entered():
	entrer=9
	pass # Replace with function body.


func _on_static_body_3d_mouse_exited():
	entrer=0
	pass # Replace with function body.


func _on_static_body_3d_2_mouse_entered():
	entrer=7
	pass # Replace with function body.


func _on_static_body_3d_2_mouse_exited():
	entrer=0
	pass # Replace with function body.


func _on_static_body_3d_3_mouse_entered():
	entrer=8
	pass # Replace with function body.


func _on_static_body_3d_3_mouse_exited():
	entrer=0
	pass # Replace with function body.
