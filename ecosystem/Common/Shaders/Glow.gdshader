shader_type canvas_item;
render_mode blend_mix, unshaded;

uniform bool highlight_enabled = true;
uniform float pulse_speed = 4.0;
uniform float pulse_strength = 1;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	if (tex.a < 0.1) {
		discard;
	}

	vec3 final_color = tex.rgb;
	float pulse = sin(TIME * pulse_speed) * 0.5 + 0.5; // normalize to 0–1

	if (highlight_enabled) {
		final_color = mix(final_color, vec3(1.0), pulse * pulse_strength);
	}

	COLOR = vec4(final_color, tex.a);
}
