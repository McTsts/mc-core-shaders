#version 150

#moj_import <light.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;
uniform sampler2D Sampler1;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 vertexColor;
out vec4 lightMapColor;
out vec4 overlayColor;
out vec2 texCoord0;
out vec4 normal;

void main() {
   gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color);
    lightMapColor = texelFetch(Sampler2, UV2 / 16, 0);
    overlayColor = texelFetch(Sampler1, UV1, 0);
    texCoord0 = UV0;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
	
	// remove capes
	vec2 texSize = textureSize(Sampler0,0);
	if(	texSize.x == 64 && texSize.y == 32 && // check if size matches a cape
			texture(Sampler0, vec2(0.0, 1.0/32.0)).a == 1.0 && texture(Sampler0, vec2(12.0/64.0, 16.0/32.0)).a == 1.0 && // check if skin transparent pixels have color
			(	// support both types of cape texture
				(texture(Sampler0, vec2(0.0, 18.0/32.0)) == vec4(1.0) && texture(Sampler0, vec2(0.99, 0.99)) == vec4(1.0) && texture(Sampler0, vec2(0.99, 0.0)) == vec4(1.0)) // for capes filled with white, check for white pixels
				|| (texture(Sampler0, vec2(25.0/64.0, 25.0/32.0)).a == 0.0 || texture(Sampler0, vec2(30.0/64.0, 10.0/32.0)).a == 0.0 || texture(Sampler0, vec2(9.0/64.0, 25.0/32.0)).a == 0.0)  // otherwise check of transparent pixels
			)
	) gl_Position = vec4(0.0);
}
