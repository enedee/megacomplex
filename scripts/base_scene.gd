class_name BaseScene extends Node

@onready var player: Player = $Player
@onready var entrance_marker: Node3D = $entrance_markers

func _ready():
	if scene_manager.player:
		if player:
			player.queue_free()
			
		player = scene_manager.player
		add_child(player)
		
	position_player()

func position_player() -> void:
	var last_scene = scene_manager.last_scene_name
	if last_scene.is_empty():
		last_scene
	for entrance in entrance_marker.get_children():
		if entrance is Marker3D and entrance.name == "any" or entrance.name == last_scene:
			print("I know where you are.")
			player.position = entrance.position
