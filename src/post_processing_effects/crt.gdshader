shader_type canvas_item;

// Based on: [https://www.shadertoy.com/view/Ms23DR](https://www.shadertoy.com/view/Ms23DR)
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// Controles de Efeito
uniform float distortion_amount : hint_range(0.0, 1.0) = 0.3; 
uniform float aberration_amount : hint_range(0.0, 1.0) = 0.3;
uniform float vignette_intensity : hint_range(0.0, 2.0) = 1.0;

vec2 curve(vec2 uv) {
	uv = (uv - 0.5) * 2.0;
	uv *= 1.05;
	uv.x *= 1.0 + (pow((abs(uv.y) / 5.0), 2.0) * distortion_amount);
	uv.y *= 1.0 + (pow((abs(uv.x) / 4.0), 2.0) * distortion_amount);
	uv  = (uv / 2.0) + 0.5;
	uv =  uv * 0.92 + 0.04;
	return uv;
}

void fragment() {
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec2 q = FRAGCOORD.xy / iResolution.xy;
	vec2 uv = curve(q);
	vec3 col;
	float x = sin(0.3 * TIME + uv.y * 21.0) * sin(0.7 * TIME + uv.y * 29.0) * sin(0.3 + 0.33 * TIME + uv.y * 31.0) * 0.0017;

	vec2 offset_r = vec2(0.001, 0.001) * aberration_amount;
	vec2 offset_g = vec2(0.000, -0.002) * aberration_amount;
	vec2 offset_b = vec2(-0.002, 0.000) * aberration_amount;

	col.r = texture(screen_texture, vec2(x + uv.x, uv.y) + offset_r).x + 0.05;
	col.g = texture(screen_texture, vec2(x + uv.x, uv.y) + offset_g).y + 0.05;
	col.b = texture(screen_texture, vec2(x + uv.x, uv.y) + offset_b).z + 0.05;

	col.r += 0.08 * texture(screen_texture, 0.75 * vec2(x + 0.025, -0.027) + vec2(uv.x, uv.y) + offset_r).x;
	col.g += 0.05 * texture(screen_texture, 0.75 * vec2(x - 0.022, -0.02) + vec2(uv.x, uv.y) + offset_g).y;
	col.b += 0.08 * texture(screen_texture, 0.75 * vec2(x - 0.02, -0.018) + vec2(uv.x, uv.y) + offset_b).z;

	col = clamp(col * 0.6 + 0.4 * col * col * 1.0, 0.0, 1.0);

	float vig = (16.0 * uv.x * uv.y * (1.0 - uv.x) * (1.0 - uv.y));
	vec3 vignette_effect = vec3(pow(vig, 0.3));
	col *= mix(vec3(1.0), vignette_effect, vignette_intensity);

	col *= vec3(0.95, 1.05, 0.95);
	col *= 2.8;

	float scans = clamp(0.35 + 0.35 * sin(3.5 * TIME + uv.y * iResolution.y * 1.5), 0.0, 1.0);
	float s = pow(scans, 1.7);
	col = col * vec3(0.4 + 0.7 * s);
	col *= 1.0 + 0.01 * sin(110.0 * TIME);
	
	if (uv.x < 0.0 || uv.x > 1.0)
		col *= 0.0;
	if (uv.y < 0.0 || uv.y > 1.0)
		col *= 0.0;

	col *= 1.0 - 0.65 * vec3(clamp((mod(FRAGCOORD.x, 2.0) - 1.0) * 2.0, 0.0, 1.0));

	COLOR = vec4(col, 1.0);
}