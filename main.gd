extends Node

@export var mob_scene: PackedScene
var score

func _ready():
	new_game()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()

func _on_score_timer_timeout() -> void:
	score = score + 1

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()


func _on_mob_timer_timeout() -> void:
	# Neuer Gegner erstellen
	var mob = mob_scene.instantiate()
	
	# Zufallige Position finden auf Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Den Gengner am zufalligen Ort platzieren
	mob.position = mob_spawn_location.position
	
	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Richtung
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Zufallige Geschwindigkeit
	var velocity = Vector2(randf_range(200.0, 300.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
