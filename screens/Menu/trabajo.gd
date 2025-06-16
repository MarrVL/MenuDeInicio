extends Control

@onready var contenedor_botones: VBoxContainer = $ContenedorBotones
@onready var panel_opciones: Panel = $PanelOpciones

func _process(delta):
	pass
	
func _ready():
	contenedor_botones.visible = true
	panel_opciones.visible = false
	
func _on_Empezar_pressed():
	get_tree().change_scene_to_file("res://screens/PanelSeleccion/PanelSeleccionSuyos.tscn")
	
func _on_opciones_pressed() -> void:
	print("Settings pressed")
	contenedor_botones.visible = false
	panel_opciones.visible = true
	
func _on_Salir_pressed():
	get_tree().quit()


func _on_regresar_opciones_pressed() -> void:
	_ready()


func _on_empezar_pressed() -> void:
	pass # Replace with function body.
