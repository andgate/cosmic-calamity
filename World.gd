extends YSort

func _on_Dialog_dialog_started():
	get_tree().paused = true

func _on_Dialog_dialog_finished():
	get_tree().paused = false
