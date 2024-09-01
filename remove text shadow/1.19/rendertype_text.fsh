#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in float depthLevel; // added: get depthLevel from vsh

out vec4 fragColor;

void main() {
    vec4 texColor = texture(Sampler0, texCoord0); // modified: separated texColor
    vec4 color = texColor * vertexColor * ColorModulator; // see above
    if (color.a < 0.1) {
        discard;
    }
    if(texColor.a == 254.0/255.0) { // added: check for opacity. 254.0 is opacity of text that should have shadow removed
        if(depthLevel == 0.00) discard; // added: remove shadow by detecting depth level
        else color = vec4(texColor.rgb, 1.0) * vertexColor * ColorModulator; // added: remove the opacity from color
    } 
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
