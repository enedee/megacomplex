extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if scene_manager.player:
		add_child(scene_manager.player)
