// Code adapted from https://gdquest.mavenseed.com/lessons/outlines-for-2d-sprites
shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0);
uniform float outline_thickness : hint_range(0, 10) = 1.0;
// 0 = inner, 1 = outer, 2 = inner outer
uniform int outline_mode : hint_range(0, 2) = 0;

uniform vec3 mod_hsv = vec3(0.0);
// 0 = off, 1 = add, 2 = mul
uniform int mod_hsv_mode : hint_range(0, 2) = 0;

vec3 hsv(vec3 rgb) {
	vec3 c = rgb;
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 rgb(vec3 hsv) {
	vec3 c = hsv;
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

const vec2 OFFSETS[8] = {
	vec2(-1, -1), vec2(-1, 0), vec2(-1, 1), vec2(0, -1), vec2(0, 1), 
	vec2(1, -1), vec2(1, 0), vec2(1, 1)
};

void fragment() {
	vec2 size = TEXTURE_PIXEL_SIZE * outline_thickness;
	vec4 color = texture(TEXTURE, UV);
	
	if (outline_mode == 0) {
		// Inner
		float outline = 1.0;
		for (int i = 0; i < OFFSETS.length(); i++) {
			outline *= texture(TEXTURE, UV + size * OFFSETS[i]).a;
		}
		outline = 1.0 - outline;
		
		vec4 outlined_result = mix(color, outline_color, outline * color.a);
		COLOR = mix(color, outlined_result, outlined_result.a);
	} else if (outline_mode == 1) {
		// Outer
		float outline = 0.0;
		for (int i = 0; i < OFFSETS.length(); i++) {
			outline += texture(TEXTURE, UV + size * OFFSETS[i]).a;
		}
		outline = min(outline, 1.0);
		
		COLOR = mix(color, outline_color, outline - color.a);
	} else if (outline_mode == 2) {
		// Inner outer
		float inline = 1.0;
		float outline = 0.0;
		for (int i = 0; i < OFFSETS.length(); i++) {
			float sample = texture(TEXTURE, UV + size * OFFSETS[i]).a;
			outline += sample;
			inline *= sample;
		}
		outline = min(1.0, outline) - color.a;
		inline = (1.0 - inline) * color.a;
		
		vec4 outlined_result = mix(color, outline_color, outline + inline);
		COLOR = mix(color, outlined_result, outlined_result.a);
	}

	if (mod_hsv_mode == 1) {
		vec3 hsv_color = hsv(COLOR.rgb);
		hsv_color += mod_hsv;
		COLOR.rgb = rgb(hsv_color);
	} else if (mod_hsv_mode == 2) {
		vec3 hsv_color = hsv(COLOR.rgb);
		hsv_color *= mod_hsv;
		COLOR.rgb = rgb(hsv_color);
	}
}