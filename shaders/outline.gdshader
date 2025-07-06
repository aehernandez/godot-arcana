// Code adapted from https://gdquest.mavenseed.com/lessons/outlines-for-2d-sprites
shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0);
uniform float outline_thickness : hint_range(0, 10) = 1.0;
// 0 = inner, 1 = outer, 2 = inner outer
uniform int outline_mode : hint_range(0, 2) = 0;

uniform vec3 mod_hsv = vec3(0.0);
// 0 = off, 1 = add, 2 = mul, 3 = sub 
uniform int mod_hsv_mode : hint_range(0, 3) = 0;

const float EPSILON = 1e-10;
vec3 HUEtoRGB(in float hue)
{
    // Hue [0..1] to RGB [0..1]
    // See http://www.chilliant.com/rgb2hsv.html
    vec3 rgb = abs(hue * 6. - vec3(3, 2, 4)) * vec3(1, -1, -1) + vec3(-1, 2, 2);
    return clamp(rgb, 0., 1.);
}

vec3 RGBtoHCV(in vec3 rgb)
{
    // RGB [0..1] to Hue-Chroma-Value [0..1]
    // Based on work by Sam Hocevar and Emil Persson
    vec4 p = (rgb.g < rgb.b) ? vec4(rgb.bg, -1., 2. / 3.) : vec4(rgb.gb, 0., -1. / 3.);
    vec4 q = (rgb.r < p.x) ? vec4(p.xyw, rgb.r) : vec4(rgb.r, p.yzx);
    float c = q.x - min(q.w, q.y);
    float h = abs((q.w - q.y) / (6. * c + EPSILON) + q.z);
    return vec3(h, c, q.x);
}

vec3 HSVtoRGB(in vec3 hsv)
{
    // Hue-Saturation-Value [0..1] to RGB [0..1]
    vec3 rgb = HUEtoRGB(hsv.x);
    return ((rgb - 1.) * hsv.y + 1.) * hsv.z;
}

vec3 HSLtoRGB(in vec3 hsl)
{
    // Hue-Saturation-Lightness [0..1] to RGB [0..1]
    vec3 rgb = HUEtoRGB(hsl.x);
    float c = (1. - abs(2. * hsl.z - 1.)) * hsl.y;
    return (rgb - 0.5) * c + hsl.z;
}

vec3 RGBtoHSV(in vec3 rgb)
{
    // RGB [0..1] to Hue-Saturation-Value [0..1]
    vec3 hcv = RGBtoHCV(rgb);
    float s = hcv.y / (hcv.z + EPSILON);
    return vec3(hcv.x, s, hcv.z);
}

vec3 RGBtoHSL(in vec3 rgb)
{
    // RGB [0..1] to Hue-Saturation-Lightness [0..1]
    vec3 hcv = RGBtoHCV(rgb);
    float z = hcv.z - hcv.y * 0.5;
    float s = hcv.y / (1. - abs(z * 2. - 1.) + EPSILON);
    return vec3(hcv.x, s, z);
}

vec3 hsv(vec3 rgb) {
	return RGBtoHSV(rgb);
}

vec3 rgb(vec3 hsv) {
	return HSVtoRGB(hsv);
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
	} else if (mod_hsv_mode == 3) {
		vec3 hsv_color = hsv(COLOR.rgb);
		hsv_color -= mod_hsv;
		COLOR.rgb = rgb(hsv_color);
	}
}