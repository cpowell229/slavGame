extends CharacterBody2D

@export var speed: float = 150.0
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

var chase = false
var player = null

func _ready():
	# Connect the collision signals from the CollisionShape2D
	$CollisionShape2D.connect("body_entered", Callable(self, "_on_body_entered"))
	$CollisionShape2D.connect("body_exited", Callable(self, "_on_body_exited"))

func _physics_process(delta: float) -> void:
	pass
	
	# Normal chasing behavior:
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		chase = true
		player = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
