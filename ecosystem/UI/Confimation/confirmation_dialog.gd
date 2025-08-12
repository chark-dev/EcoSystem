extends ConfirmationDialog


signal user_decision(continue_simulation: bool)




func _on_confirmed() -> void:
#	Continue 
	user_decision.emit(true)
	hide()


func _on_canceled() -> void:
	# Stop 
	user_decision.emit(false)
	hide()
