extends Sleeping
class_name RabbitSleeping 



func process_physics(delta):
	awake_timer -= delta
	
	if awake_timer <= 0:
		parent.show()
		return idle_state

#If food + hunger is at a certain level, + safe 
# Sleep for a while
# Process stat changes while 
# after sleep timer runs out, wake up + return to idle 
func enter():
	parent.label.text = "Sleeping"

func exit():
	parent.sleep_timer = 30
	awake_timer = 30
