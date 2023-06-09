extends Control

func _on_restert_button_pressed():
	get_tree().reload_current_scene()

func set_score(value):
	$Panel/Score.text = "Score\n" + str(value)
