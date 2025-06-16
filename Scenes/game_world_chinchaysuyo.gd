extends Node2D

func _on_btn_back_panel_pressed():
	print("Regresando al menú principal...")
	#deveriamos cambiar la ubicacion del menu dentro de screen algo asi res://screens/MainMenu.tscn
	get_tree().change_scene_to_file("res://screens/PanelSeleccion/PanelSeleccionSuyos.tscn") 
