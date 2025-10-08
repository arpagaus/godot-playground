extends Node

@export var mob_scene: PackedScene
var score

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Music.play()

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$GameOver.play()

func _on_score_timer_timeout() -> void:
	score = score + 1
	$HUD.update_score(score)

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
	var velocity = Vector2(randf_range(150.0, 200.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
