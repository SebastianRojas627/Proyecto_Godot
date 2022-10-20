extends KinematicBody2D

const ACCEL = 650
const MAX_SPEED = 100

var bullet = preload("res://scenes/Bullet/Bullet.tscn")
var bullet_speed = 1000
var fire_rate = 0.5
var can_fire = true

var hp = 10
var velocity = Vector2.ZERO
onready var state_machine = $AnimationTree.get("parameters/playback")
var hit = false
var die = false

func _physics_process(delta):
	
	if Input.is_action_pressed("shoot") and can_fire:
		state_machine.travel("shoot")
		var bullet_instance = bullet.instance()
		bullet_instance.position = $Position2D.get_node("Gun_barrel").get_global_position()
		#bullet_instance.rotation_degrees = rotation_degrees
		if $Sprite.scale.x == -1:
			bullet_instance.apply_impulse(Vector2(), Vector2(-bullet_speed, 0))
		else:
			bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0))
		get_tree().get_root().add_child(bullet_instance)
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
	
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		input_vector += Vector2(0, -1)
	if Input.is_action_pressed("ui_down"):
		input_vector += Vector2(0, 1)
	if Input.is_action_pressed("ui_left"):
		input_vector += Vector2(-1, 0)
	if Input.is_action_pressed("ui_right"):
		input_vector += Vector2(1, 0)
		
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCEL * delta)
		state_machine.travel("run")
	else:
		velocity = Vector2.ZERO
		state_machine.travel("idle")
		
	if velocity.x < 0:
		$Sprite.scale.x = -1
		$Position2D.scale.x = -1
	elif velocity.x > 0:
		$Sprite.scale.x = 1
		$Position2D.scale.x = 1
		
	velocity = move_and_slide(velocity)
	
	if hit:
		state_machine.travel("hit")
		hit = false
		
	if die:
		state_machine.travel("death")
		velocity = Vector2.ZERO
		get_tree().change_scene("res://scenes/Death/Death_screen.tscn")
		

func _on_Hitbox_area_entered(area):
	hit = true
	hp -= 1
	if hp <= 0:
		die = true
	
