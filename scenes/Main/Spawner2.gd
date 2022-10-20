extends Node2D

const WIDTH = 125
const HEIGHT = 300
const ENEMY = preload("res://scenes/Enemy/Enemy.tscn")

var spawn_area = Rect2()

var delta = 5
var offset = 3


func _ready():
	randomize()
	spawn_area = Rect2(0, 0, WIDTH, HEIGHT)
	set_next_spawn()
	
func spawn_enemy():
	var position = Vector2((randi()%WIDTH) + 1250, (randi()%HEIGHT) + HEIGHT)
	var enemy = ENEMY.instance()
	enemy.position = position
	$"../".add_child(enemy)
	return position
	
func set_next_spawn():
	var next_time = delta + (randf()-0.5)*2*offset
	$Timer.wait_time = next_time
	$Timer.start()
	
func _on_Timer_timeout():
	spawn_enemy()
	set_next_spawn()
