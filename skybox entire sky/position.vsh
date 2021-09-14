#version 150

in vec3 Position;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out float vertexDistance;

// from: https://github.com/onnowhere/core_shaders/blob/master/.shader_utils/vsh_util.glsl
bool isGUI(mat4 ProjMat) {
    return ProjMat[3][2] == -2.0;
}

void main() { 
	vec4 pos = vec4(Position, 1.0);
	if(!isGUI(ProjMat)) { // make sky cover entire sky
		pos = ProjMat * vec4(Position, 1.0);
		pos.y = -pos.z;
	} else { // vanilla behaivor (for text highlight)
		pos = ProjMat * ModelViewMat * vec4(Position, 1.0);
	}
	
	gl_Position = pos;
    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
}
