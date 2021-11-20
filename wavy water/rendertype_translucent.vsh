#version 150

#moj_import <light.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform float GameTime;

uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec3 ChunkOffset;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 normal;

void main() {
	// position
	vec3 position = Position + ChunkOffset;

	vec4 color = texture(Sampler0, UV0);
	// wavy water
	if(Color.r < 0.4 && Color.r > 0.1 && Color.b > 0.2 && color.a < 0.8 && color.a > 0.4 && color.b == color.g && color.g == color.r && Color.r != Color.b) { // identify water
		// options
		float waveSize = 2.0; // determines wave size
		float waveHeight = 30.0; // height
		// calculation
		float timer = GameTime * 2000.0; // game time, determines amount of waves
		float offset = sin(round(position.x / waveSize) + timer) - cos(round(position.z / waveSize) + timer); // calculate offset
		position = position + vec3(0.0, offset / waveHeight - 0.025, 0.0);
	}

	// position
	gl_Position = ProjMat * ModelViewMat * vec4(position, 1.0);
	// vanilla stuff
	vertexDistance = length((ModelViewMat * vec4(Position + ChunkOffset, 1.0)).xyz);
    vertexColor = Color * minecraft_sample_lightmap(Sampler2, UV2);
    texCoord0 = UV0;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
