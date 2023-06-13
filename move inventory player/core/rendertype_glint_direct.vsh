#version 150

#moj_import <fog.glsl>
#moj_import <util.glsl>

in vec3 Position;
in vec2 UV0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform mat4 TextureMat;
uniform int FogShape;

out float vertexDistance;
out vec2 texCoord0;
float depth = -(ModelViewMat * vec4(1.0)).z;
void main() {
    if(isInvTop(ModelViewMat, ProjMat) && depth < 1000) { // detects it's being rendered in their inventory
		gl_Position = (ProjMat * ((ModelViewMat * vec4(Position, 1.0))  + INV_OFFSET)); // offset
	} else {
		gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
	}

    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    texCoord0 = (TextureMat * vec4(UV0, 0.0, 1.0)).xy;
}
