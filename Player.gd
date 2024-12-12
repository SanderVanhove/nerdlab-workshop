extends CharacterBody2D


const MAX_SPEED = 200.0
const ACCELERATION = 500.0
const DECELERATION = 800.0
const JUMP_VELOCITY = -300.0


@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var jump_particles: GPUParticles2D = $JumpParticles


var speed: float = 0.0
var can_double_jump: bool = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		can_double_jump = true

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_sound.play()
			jump_particles.emitting = true
		elif can_double_jump:
			velocity.y = JUMP_VELOCITY
			can_double_jump = false
			jump_sound.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		speed = move_toward(speed, MAX_SPEED, ACCELERATION * delta)
		velocity.x = direction * speed
	else:
		speed = 0.0
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)

	move_and_slide()
