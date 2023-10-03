shader_type canvas_item;

uniform float intensity : hint_range(0.0, 1.0);


uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

void fragment() {
	vec2 uv = SCREEN_UV;
//	vec2 uv = UV;
	uv -= mod(uv, vec2(max(0.001, intensity)/10.0, max(0.001, intensity)/10.0));//size_x, size_y));
//	uv -= mod(uv, vec2(size_x, size_y));

	COLOR.rgb = textureLod(SCREEN_TEXTURE, uv, 0.0).rgb;
}