extends Control	

func _on_Quit_pressed():
	get_tree().quit()

func _on_Menu_pressed():
	get_tree().change_scene("res://scenes/MainMenu/Menu.gd")
