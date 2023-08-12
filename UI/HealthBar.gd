extends ProgressBar

func _process(delta):
	if Global.player:
		value = Global.player.current_health
