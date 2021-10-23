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

// custom values
flat out int skinEffects;
flat out vec4 data1Color;
flat out vec4 data2Color;
flat out int isFace;

#define EQ(a,b) (length(a - b) < 0.002)

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color);
    lightMapColor = texelFetch(Sampler2, UV2 / 16, 0);
    overlayColor = texelFetch(Sampler1, UV1, 0);
    texCoord0 = UV0;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
	
	/* custom skin stuff */
	skinEffects = 0;
	if(EQ(texture(Sampler0, vec2(63.0/64.0, 0.0)), vec4(117.0/255.0, 117.0/255.0, 145.0/255.0, 187.0/255.0))) skinEffects = 1; // check for a specific pixels which enables the effects
	// get colors
    data1Color = texture(Sampler0, vec2(62.0/64.0, 0.0)); // get data pixel #1
    data2Color = texture(Sampler0, vec2(61.0/64.0, 0.0)); // get data pixel #2
	// detect if rendering face texture (=> blinking)
	isFace = 0;
	if(gl_VertexID >= 16 && gl_VertexID < 20) isFace = 1; // check if the vertex ids match the face
}
