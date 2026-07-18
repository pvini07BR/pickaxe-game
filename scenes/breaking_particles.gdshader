shader_type canvas_item;

uniform uint atlas_count = 3;
uniform int atlas_id : hint_range(0, 2) = 0;
uniform uint particle_size = 6;

float random(uint n) {
	n = (n << 13U) ^ n;
	n = n * (n * n * 15731U + 789221U) + 1376312589U;
	return float(n & uint(0x7fffffffU)) / float(0x7fffffff);
}

void vertex() {
	float rand_x = random(uint(INSTANCE_ID));
	float rand_y = random(uint(INSTANCE_ID) + 12345U);
	
	float f_particle_size = float(particle_size);
	float f_atlas_count = float(atlas_count);
	
	float chunk_col = floor(rand_x * f_particle_size);
	float chunk_row = floor(rand_y * f_particle_size);
	
	vec2 chunk_size = vec2(1.0 / (f_atlas_count * f_particle_size), 1.0 / f_particle_size);
	
	float block_base_offset_x = float(atlas_id) / f_atlas_count;
	
	vec2 final_offset = vec2(
		block_base_offset_x + (chunk_col * chunk_size.x),
		chunk_row * chunk_size.y
	);
	
	UV = (UV * chunk_size) + final_offset;
	VERTEX *= chunk_size;
}