extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var entrer=0
# Called when the node enters the scene tree for the first time.
signal param(entrer)
# Called when the node enters the scene tree for the first time.

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if entrer !=0:
				emit_signal("param",entrer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StaticBody_mouse_entered():
	entrer=3
	pass # Replace with function body.


func _on_StaticBody_mouse_exited():
	entrer=0
	pass # Replace with function body.


func _on_StaticBody2_mouse_entered():
	entrer=4
	pass # Replace with function body.


func _on_StaticBody2_mouse_exited():
	entrer=0
	pass # Replace with function body.


func _on_StaticBody3_mouse_entered():
	entrer=5
	pass # Replace with function body.


func _on_StaticBody3_mouse_exited():
	entrer=0
	pass # Replace with function body.
