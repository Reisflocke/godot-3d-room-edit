extends KinematicBody

const SPEED := 3.0

func _physics_process(delta):
	var d_speed = SPEED * delta
	
	if Input.is_key_pressed(KEY_A):
		move_and_collide(Vector3(-d_speed, 0, 0))
	if Input.is_key_pressed(KEY_D):
		move_and_collide(Vector3(d_speed, 0, 0))
	if Input.is_key_pressed(KEY_W):
		move_and_collide(Vector3(0, 0, -d_speed))
	if Input.is_key_pressed(KEY_S):
		move_and_collide(Vector3(0, 0, d_speed))

