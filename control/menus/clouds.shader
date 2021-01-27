shader_type canvas_item;

uniform vec4 base_color : hint_color;
uniform float lowerlevel_speed = 0.3;
uniform float toplevel_speed = 0.9;
uniform float clarity = 2.9;
uniform float foam_average = 0.0;
uniform float foam_max = 1.4;
uniform float zoom_level = 3.1;
uniform float square_count = 1001.5850;

float rand(vec2 n) { 
	return fract(sin(dot(n, vec2(0.360,0.690))) * square_count);
}

float noise(vec2 p){
	vec2 ip = floor(p);
	vec2 u = fract(p);
	u = u*u*(3.0-2.0*u);
	
	float res = mix(
		mix(rand(ip),rand(ip+vec2(1.0,0.0)),u.x),
		mix(rand(ip+vec2(0.0,1.0)),rand(ip+vec2(1.0,1.0)),u.x),u.y);
	return res*res;
}

void fragment(){
	vec2 uv = UV;
	vec3 color = vec3(base_color.r,base_color.g,base_color.b);
	float speed = TIME * lowerlevel_speed;
	const int n = 15;
	float awan = foam_average;
    float d = foam_max;
    vec2 pos = uv*zoom_level;
    for(int i = 0; i < n; i++){
        awan += noise(pos) / d;
        pos *= clarity;
        d *= 2.064;
        pos -= speed * 0.12 * pow(d, toplevel_speed);
    }
    color += pow(abs(awan), 2.604);
    COLOR = vec4(color,1.0);
}
