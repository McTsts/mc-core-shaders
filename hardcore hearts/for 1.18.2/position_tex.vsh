#version 150

uniform sampler2D Sampler0;

in vec3 Position;
in vec2 UV0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec2 texCoord0;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    texCoord0 = UV0;
   
   // added by Ts
    vec2 texSize = textureSize(Sampler0,0); // get atlas size
    vec2 coords = round(UV0 * texSize); // get int coords
    if(texSize.x == 256 && texSize.y == 256 // correct atlas size
        && coords.x >= 16 && coords.x <= 190 && coords.y <= 9 // roughly right uv pos
        && Position.z == 0.0 // right z level
        && gl_VertexID < 4 // low vertex id
        && ProjMat[3][2] == -2.0 // is gui
        && mod(coords.x - 16, 9) == 0 && mod(coords.y, 9) == 0 // vertices correctly positioned
        && ((gl_VertexID == 2 || gl_VertexID == 3) && round(coords.y) == 0 || (gl_VertexID == 0 || gl_VertexID == 1) && round(coords.y) == 9) // more precise vertex position check
    ) {
        texCoord0.y = texCoord0.y + (45/texSize.y); // offset 45 pixels down
    }
}
