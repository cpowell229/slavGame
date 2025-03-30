extends Node2D

func spawn_vampire():
	var vampire_scene = preload("res://Vampire.tscn")
	var vampire = vampire_scene.instantiate()
	
	# Use get_node() with the correct path to your Player.
	# If your Player is a direct child and is named "Player", this works:
	var player = get_node("Player")
	
	if player:
		# Spawn near the player (50 pixels to the right)
		vampire.global_position = player.global_position + Vector2(50, 0)
	else:
		# Fallback spawn position
		vampire.global_position = Vector2(500, 300)
	
	add_child(vampire)
	print("Vampire spawned near player!")
