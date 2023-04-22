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

uniform float GameTime;
uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 vertexColor;
out vec4 lightMapColor;
out vec4 overlayColor;
out vec2 texCoord0;
out vec4 normal;

flat out int skinEffects;
flat out int isFace;
flat out vec3 Times;

void main() {
    //skin effects
    skinEffects = 0;
    isFace = 0;
    vec4 skindata = texture(Sampler0, vec2(0.5, 0.0));
    //face vertices
    if(((gl_VertexID >= 16 && gl_VertexID < 20) || (gl_VertexID >= 160 && gl_VertexID < 164))) {
        isFace = 1;
    }
    //enable blink
    if (abs(skindata.a - 0.918) < 0.001) {
        skinEffects = 1;
        Times = skindata.rgb;
    }
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color);
    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
    lightMapColor = texelFetch(Sampler2, UV2 / 16, 0);
    overlayColor = texelFetch(Sampler1, UV1, 0);
    texCoord0 = UV0;
}