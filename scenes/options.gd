extends PanelContainer

func _on_eng_button_pressed() -> void:
	TranslationServer.set_locale("english")

func _on_pt_button_pressed() -> void:
	TranslationServer.set_locale("portuguese")

func _on_close_button_pressed() -> void:
	self.visible = false
	get_parent().get_node("BGFade").visible = false
