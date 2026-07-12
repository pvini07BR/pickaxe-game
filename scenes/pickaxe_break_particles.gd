extends Node2D

var pick_data: Pickaxe = null

@onready var handle_particles: CPUParticles2D = $HandleParticles
@onready var head_particles: CPUParticles2D = $HeadParticles

func _ready() -> void:
	if pick_data:
		handle_particles.texture = pick_data.handle_material.texture
		head_particles.texture = pick_data.head_material.texture
	
	handle_particles.emitting = true
	head_particles.emitting = true

func _on_handle_particles_finished() -> void:
	self.queue_free()
