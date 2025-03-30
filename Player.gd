extends CharacterBody2D

@export var speed: float = 300.0
@export var inventory: Array = []

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("player")  # So that coins and the vampire can detect the player

func move(direction):
	if direction == null:
		velocity = Vector2.ZERO
		return

	var new_vel = Vector2.ZERO
	match direction:
		Globals.InputDirection.LEFT:
			new_vel.x = -1
		Globals.InputDirection.RIGHT:
			new_vel.x = 1
		Globals.InputDirection.UP:
			new_vel.y = -1
		Globals.InputDirection.DOWN:
			new_vel.y = 1
	velocity = new_vel * speed

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	# Update animation based on whether we're moving
	if velocity.length() > 0:
		anim_sprite.play("new_animation_1")      # Moving animation
	else:
		anim_sprite.play("new_animation")      # Idle animation

# This function is called when the player collects a gem.
func add_to_inventory(item):
	inventory.append(item)
	print("Picked up: ", item)
	
	# If three or more gems are collected and the vampire hasn't spawned yet, spawn it.
	if inventory.size() >= 3 and not Globals.vampire_spawned:
		Globals.vampire_spawned = true
		# Assuming the main scene has a spawn_vampire() function.
		get_tree().current_scene.spawn_vampire()
