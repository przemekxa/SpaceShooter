extends Node2D

@export var enemy_scenes: Array[PackedScene] = []

@onready var player = $Player
@onready var player_spawn_position = $PlayerSpawnPosition
@onready var fireball_container = $FireballContainer
@onready var timer = $EnemySpawnTimer
@onready var enemy_container = $EnemyContainer
@onready var hud = $Interface/HUD
@onready var game_over_screen = $Interface/GameOverScreen
@onready var parallax_background = $ParallaxBackground

@onready var fire_sound = $Sounds/FireSound
@onready var hit_sound = $Sounds/HitSound
@onready var game_over_sound = $Sounds/GameOverSound

var score := 0:
	set(value):
		score = value
		hud.score = score

# Called when the node enters the scene tree for the first time.
func _ready():
	hud.score = 0
	player.global_position = player_spawn_position.global_position
	player.fireball_shot.connect(_on_player_fireball_shot)
	player.killed.connect(_on_player_killed)

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
		
	if timer.wait_time > 0.5:
		timer.wait_time -= delta * 0.01
	elif timer.wait_time < 0.5:
		timer.wait_time = 0.5
		
	parallax_background.scroll_offset.y += delta * 100.0
	while parallax_background.scroll_offset.y >= 1080.0:
		parallax_background.scroll_offset.y -= 1080.0

func _on_player_fireball_shot(fireball_scene, location):
	var fireball = fireball_scene.instantiate()
	fireball.global_position = location
	fireball_container.add_child(fireball)
	fire_sound.play()

func _on_enemy_spawn_timer_timeout():
	var enemy = enemy_scenes.pick_random().instantiate()
	enemy.position = Vector2(randf_range(0.0 + 50.0, 810.0 - 50.0), -100.0)
	enemy.killed.connect(_on_enemy_killed)
	enemy.hit.connect(_on_enemy_hit)
	enemy_container.add_child(enemy)

func _on_enemy_killed(worth):
	score += worth

func _on_enemy_hit():
	hit_sound.play()
	
func _on_player_killed():
	game_over_screen.set_score(score)
	await get_tree().create_timer(0.1).timeout
	game_over_sound.play()
	game_over_screen.visible = true
