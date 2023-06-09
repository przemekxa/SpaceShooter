class_name Player extends CharacterBody2D

const SPEED = 300.0
const SHOOT_COOLDOWN = 0.2

signal fireball_shot(fireball_scene, location)
signal killed

var fireball_scene = preload("res://scenes/fireball.tscn")

@onready var shoot_point = $ShootPoint

var shoot_cooldown := false

func _process(delta):
	if Input.is_action_pressed("shoot"):
		if !shoot_cooldown:
			shoot_cooldown = true
			shoot()
			await get_tree().create_timer(SHOOT_COOLDOWN).timeout
			shoot_cooldown = false

func _physics_process(delta):
	var direction = Vector2(
		Input.get_axis("move_left", "move_right"), 
		Input.get_axis("move_up", "move_down")
	)
	velocity = direction * SPEED

	move_and_slide()
	
	global_position = global_position.clamp(Vector2.ZERO, get_viewport_rect().size)

func shoot():
	fireball_shot.emit(fireball_scene, shoot_point.global_position)
	
func die():
	killed.emit()
	queue_free()
