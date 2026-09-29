shader_type canvas_item;

uniform float speed = 0.4;
uniform float repeat_x = 4.6829268;

void fragment() {
	vec2 uv = UV;
	uv.x = fract(uv.x * repeat_x + TIME * speed);
	COLOR = texture(TEXTURE, uv);
}
