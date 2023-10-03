shader_type canvas_item;

uniform float intensity : hint_range(0.0, 1.0);

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

const float SAMPLES = 35.0;
const float PI2 = 6.28319;
const vec2 BLUR_SCALE = vec2(6,3);

float gaussian(float x) {
	float x_squared = x * x;
	float width = 1.0 / sqrt(PI2 * SAMPLES);
	
	return width * exp((x_squared / (2.0 * SAMPLES)) * -1.0);
}

void fragment() {
	vec2 scale = SCREEN_PIXEL_SIZE * BLUR_SCALE;
	float weight = 0.0;
	float total_weight = 0.0;
	vec4 color = vec4(0.0);
	
	for (int i =-int(SAMPLES)/2; i < int(SAMPLES)/2; ++i) {
		weight = gaussian(float(i));
		color.rgb += texture(SCREEN_TEXTURE, SCREEN_UV + scale * vec2(float(i))).rgb * weight;
		total_weight += weight;
		COLOR.rgb = mix(texture(SCREEN_TEXTURE, SCREEN_UV).rgb, color.rgb / total_weight, intensity);
	}
}
