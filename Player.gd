extends CharacterBody2D

@export var speed: float = 300.0
@export var inventory: Array = []

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_attacking: bool = false

func _ready() -> void:
	add_to_group("player")  # So that coins and the vampire can detect the player
	# Connect the animation_finished signal using a Callable (Godot 4 syntax).
	anim_sprite.connect("animation_finished", Callable(self, "_on_AnimatedSprite2D_animation_finished"))

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
	# If the attack action is triggered and we're not already attacking, play the attack animation.
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		anim_sprite.play("new_animation_2")
	
	# Continue physics processing regardless of attack state.
	move_and_slide()
	
	# Only update the default animations if not currently attacking.
	if not is_attacking:
		# Update animation based on whether we're moving.
		if velocity.length() > 0:
			anim_sprite.play("new_animation_1")  # Moving animation
		else:
			anim_sprite.play("new_animation")      # Idle animation

# This callback resets the attack state when the attack animation finishes.
func _on_AnimatedSprite2D_animation_finished():
	if is_attacking and anim_sprite.animation == "new_animation_2":
		is_attacking = false

# This function is called when the player collects a gem.
func add_to_inventory(item):
	inventory.append(item)
	print("Picked up: ", item)
	
	# If three or more gems are collected and the vampire hasn't spawned yet, spawn it.
	if inventory.size() >= 3 and not Globals.vampire_spawned:
		Globals.vampire_spawned = true
		# Assuming the main scene has a spawn_vampire() function.
		get_tree().current_scene.spawn_vampire()
