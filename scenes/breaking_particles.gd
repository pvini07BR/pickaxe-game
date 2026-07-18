extends CPUParticles2D

class_name BreakingParticles

func emit(atlas_id: int, new_amount: int, particle_size: int):
	var mat = material as ShaderMaterial
	mat.set_shader_parameter("atlas_id", atlas_id)
	mat.set_shader_parameter("particle_size", particle_size)
	#self.material = mat
	self.amount = new_amount
	emitting = true

func _on_finished() -> void:
	self.queue_free()
