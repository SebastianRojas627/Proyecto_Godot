extends KinematicBody2D

const speed = 55
onready var state_machine = $AnimationTree.get("parameters/playback")
var velocity = Vector2()

var hurt = false
var die = false
var hp = 2

func _physics_process(delta):
	
	state_machine.travel("run")
	var toPlayer = ($"../Player".global_position - global_position).normalized()
	velocity = toPlayer * speed
	move_and_collide(velocity * delta)
	
	if toPlayer.x > 0:
		$Sprite.scale.x = 1
	else:
		$Sprite.scale.x = -1
		
	if hurt:
		state_machine.travel("hit")
		hurt = false
	
	if die:
		state_machine.travel("death")
		velocity = Vector2.ZERO
		queue_free()

func _on_Hurtbox_area_entered(area):
	hurt = true
	hp -= 1
	if hp <= 0:
		die = true
	print(area)
