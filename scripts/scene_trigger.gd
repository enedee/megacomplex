class_name SceneTrigger extends Area3D

@export var connected_scene: String #name of intended destination scene
var scene_folder = "res://scenes/levels/"

func _on_body_entered(body):
	if body is Player:
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		scene_manager.change_scene(get_owner(), connected_scene)
