shader_type canvas_item;

uniform float time;

void vertex() {
    float breath = sin(TIME * 3.0) * 3.0;
    VERTEX.y += breath;
}

void fragment() {
    COLOR = vec4(0.3, 0.2, 0.1, 1.0); // Brownish rat color
}
