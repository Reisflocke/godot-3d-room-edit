shader_type spatial;
render_mode unshaded, depth_test_disable, shadows_disabled, ambient_light_disabled;

uniform bool active = false;
uniform vec4 active_color : hint_color = vec4(1.0);
uniform vec4 passive_color : hint_color = vec4(1.0, 0.0, 0.0, 1.0);


void fragment() {
	vec3 albedo_color;
	if (active) {
		albedo_color = active_color.rgb;
	} else {
		albedo_color = passive_color.rgb;
	}
	
	ALBEDO = albedo_color;
	ALPHA = 0.0625;
}