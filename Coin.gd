extends Node2D


signal picked_up


@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var timer: Timer = $Timer
@onready var tile_0151: Sprite2D = $Tile0151
@onready var pick_up_sound: AudioStreamPlayer2D = $PickUpSound


var body_to_hover_to


func _ready():
	set_process(false)


func _process(delta: float) -> void:
	global_position = lerp(global_position, body_to_hover_to.global_position, 10.0 * delta)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body_to_hover_to:
		return
	set_process(true)
	body_to_hover_to = body
	timer.start()


func _on_timer_timeout() -> void:
	gpu_particles_2d.emitting = true
	tile_0151.hide()
	pick_up_sound.play()
	
	await get_tree().create_timer(0.3).timeout
	
	queue_free()
	picked_up.emit()
