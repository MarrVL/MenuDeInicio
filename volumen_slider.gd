extends HSlider

@export var audio_bus_name: String  # Debe ser el nombre exacto del bus (ej. "Master")

var audio_bus_id: int

func _ready():
	audio_bus_id = AudioServer.get_bus_index(audio_bus_name)
	var current_db = AudioServer.get_bus_volume_db(audio_bus_id)
	value = db_to_linear(current_db)  # Ajusta el slider para que refleje el volumen actual
  # Para que el slider muestre el volumen actual
		
func _on_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_bus_id, db)
