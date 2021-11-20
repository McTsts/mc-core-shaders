#version 150

in vec3 Position;
in vec2 UV0;
in vec4 Color;
in ivec2 UV2;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out float vertexDistance;
out vec2 texCoord0;
out vec4 vertexColor;

void main() {
	// vanilla calculations
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
	texCoord0 = UV0;
	
	// prepare value
	int gridSize = 16; // size of particle textures
	vec2 texSize = textureSize(Sampler0,0); // get the size of the texture atlas
	vec2 texCoordNoOffset = UV0*texSize; // convert from [0..1] to coordinates
	texCoordNoOffset.x = texCoordNoOffset.x - mod(texCoordNoOffset.x, gridSize);  // set UV to top left corner
	texCoordNoOffset.y = texCoordNoOffset.y - mod(texCoordNoOffset.y, gridSize);  // set UV to top left corner
	// undo random offset
	vec4 cornerColor = texture(Sampler0, (texCoordNoOffset+0.5) / texSize); // get color
	if(cornerColor.a == 254.0/255.0) { 	// check opacity
		switch(gl_VertexID % 4) {
			case 0: texCoordNoOffset = texCoordNoOffset + gridSize; break; // offset to bottom right corner
			case 1: texCoordNoOffset.x = texCoordNoOffset.x + gridSize; break; // offset to top right corner
			case 3: texCoordNoOffset.y = texCoordNoOffset.y + gridSize; break; // offset to bottom left corner
		}
		texCoord0 = texCoordNoOffset / texSize; // convert from coordinates back to [0..1]
	}
}
