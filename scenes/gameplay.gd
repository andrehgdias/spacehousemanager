extends NodeState

@export var game_manager: GameManager

func _on_enter() -> void:
	pass


func _on_process(delta : float) -> void:
	if(game_manager.hub_installed):
		game_manager.pass_time(delta)

func _on_physics_process(_delta : float) -> void:
	pass
	
	
func _on_next_transitions() -> void:
	pass

func _on_exit() -> void:
	pass
