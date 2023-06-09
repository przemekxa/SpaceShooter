class_name Enemy extends Area2D

@export var speed = 300.0
@export var health = 1
@export var worth = 1

signal killed(worth)
signal hit

func _physics_process(delta):
	global_position.y += speed * delta;

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func die():
	queue_free()

func take_damage(amount):
	health -= amount
	hit.emit()
	if health <= 0:
		killed.emit(worth)
		die()

func _on_body_entered(body):
	if body is Player:
		body.die()
		die()
