extends CharacterBody2D

@export var speed: float = 150.0
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

var conversation_ready: bool = false
var target_player: Node = null  # The player who is in range

func _ready():
	# Connect the collision signals from the CollisionShape2D
	$CollisionShape2D.connect("body_entered", Callable(self, "_on_body_entered"))
	$CollisionShape2D.connect("body_exited", Callable(self, "_on_body_exited"))

func _physics_process(delta: float) -> void:
	# If the player is in range and we're waiting for input:
	if conversation_ready:
		# Stop chasing while in conversation mode.
		velocity = Vector2.ZERO
		# Optionally, you could display a UI prompt here: "Press Space to talk"
		if Input.is_action_just_pressed("ui_accept"):
			start_conversation(target_player)
			conversation_ready = false
		return  # Skip normal chasing while waiting for conversation trigger.
	
	# Normal chasing behavior:
	if target_player:
		var direction = (target_player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		if velocity.length() > 0:
			anim_sprite.play("walk")  # Ensure this animation exists.
	else:
		# If no player is currently in range, optionally idle:
		velocity = Vector2.ZERO
		anim_sprite.play("idle")  # Or your idle animation.

func _on_body_entered(body):
	# When the player enters collision range, flag conversation readiness.
	if body.is_in_group("player"):
		conversation_ready = true
		target_player = body
		print("Player in range. Press Space to talk.")

func _on_body_exited(body):
	# When the player leaves collision range, clear the flag.
	if body.is_in_group("player"):
		conversation_ready = false
		target_player = null

func start_conversation(player):
	# Create a confirmation dialog for the conversation.
	var dialog = ConfirmationDialog.new()
	dialog.dialog_text = "The vampire says:\n'Join me and become a vampire, or refuse and meet your end!'"
	
	# Add custom buttons.
	var btn_convert = dialog.add_button("Become a Vampire", true)
	var btn_kill = dialog.add_button("No, kill me", false)
	
	# Connect the buttons.
	btn_convert.connect("pressed", Callable(self, "_on_convert_chosen"), [player, dialog])
	btn_kill.connect("pressed", Callable(self, "_on_kill_chosen"), [player, dialog])
	
	add_child(dialog)
	dialog.popup_centered()

func _on_convert_chosen(player, dialog):
	dialog.queue_free()
	if player.has_method("become_vampire"):
		player.become_vampire()
	print("Player has been converted!")
	queue_free()  # Remove the vampire after conversion.

func _on_kill_chosen(player, dialog):
	dialog.queue_free()
	print("Player has been killed by the vampire!")
	player.queue_free()
	# Optionally change to a Game Over scene.
	get_tree().change_scene("res://GameOver.tscn")
