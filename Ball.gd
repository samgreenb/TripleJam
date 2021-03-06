extends RigidBody2D

onready var ani = $AnimatedSprite
onready var sound = $AudioStreamPlayer
onready var ball_counter = $"/root/BallCounter"

var can_destroy = 0
var xspeed = 300
var yspeed = 300
var minxspeed = 300
var r = RandomNumberGenerator.new()

signal created

func _ready():
	r.randomize()
	var rr = r.randi_range(1,4)
	ani.animation= String(rr)
	
	set_inertia(100000)
	
	can_destroy = 0
	
	if global_position[0] < 512:
		linear_velocity[0] = xspeed
	else:
		linear_velocity[0] = -xspeed
		
	angular_velocity = 0
	
	connect("created",ball_counter,"add_ball")
	emit_signal("created")
	connect("tree_exited",ball_counter,"remove_ball")
	ball_counter.connect("game_ended",self,"queue_free")
	
func _physics_process(_delta):
	if linear_velocity[0] < 0:
		linear_velocity[0] = -xspeed
	elif linear_velocity[0] >= 0:
		linear_velocity[0] = xspeed
		
	if linear_velocity[1] < 0:
		linear_velocity[1] = -xspeed
	elif linear_velocity[1] >= 0:
		linear_velocity[1] = xspeed
		
	if (global_position.x < 0
			or global_position.x > 1024
			or global_position.y < 0
			or global_position.y > 600):
				queue_free()

func first_ball():
	r.randomize()
	global_position[1] = r.randi_range(100,500)
	if r.randi_range(1,2) == 1:
		linear_velocity[1]=yspeed
	else:
		linear_velocity[1] =-yspeed

func _on_Ball_body_exited(body):
	if can_destroy == 1 and body.get_name() == "Brick":
		can_destroy = 0
		body.destroy()
	else:
		sound.play()

func _on_Area2D_area_entered(_area):
	can_destroy = 1

func _on_Gol_area_entered(_area):
	queue_free()
