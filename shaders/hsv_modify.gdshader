shader_type canvas_item;
uniform vec3 mod_hsv = vec3(0.0);
uniform bool true_add_false_mul = true;

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

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	vec3 color_hsv = hsv(texture_color.rgb);
	
	if (true_add_false_mul) {
		color_hsv += mod_hsv;
	} else {
		color_hsv *= mod_hsv;
	}

	COLOR.rgba = vec4(rgb(color_hsv),texture_color.a);
}