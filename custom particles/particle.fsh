#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec2 texCoord0;
in vec4 vertexColor;

out vec4 fragColor;

void main() {
	// fix texture
    vec4 color = texture(Sampler0, texCoord0);
	if(color.a == 254.0/255.0) {
		if(color.rgb == vec3(1.0,0.0,0.0)) discard;
		else color.a = 1.0;
	}
	
	// vanilla calculations
	color = color * vertexColor * ColorModulator;
    if (color.a < 0.1) {
        discard;
    }
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
