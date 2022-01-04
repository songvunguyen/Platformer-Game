extends Button


func _ready():
	pass


func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://TitleMenu.tscn")


func _on_Restart_pressed():
	get_tree().change_scene("res://Level1.tscn")


func _on_Next_pressed():
	pass # Replace with function body.
