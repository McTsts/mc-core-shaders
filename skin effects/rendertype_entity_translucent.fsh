#version 150

#moj_import <fog.glsl>

uniform mat4 ProjMat;
uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform float GameTime;

in float vertexDistance;
in vec4 vertexColor;
in vec4 lightMapColor;
in vec4 overlayColor;
in vec2 texCoord0;
in vec4 normal;

flat in int skinEffects;
flat in int isFace;
flat in vec3 Times;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0);

    //blink effect
    vec2 texSize = textureSize(Sampler0,0);
    if(skinEffects == 1 && (texCoord0.y > 0.125 && texCoord0.y < 0.25) && ((texCoord0.x > 0.125 && texCoord0.x < 0.25) || (texCoord0.x > 0.625 && texCoord0.x < 0.75))) {
        //grab second frame with offset
        vec4 color2 = texture(Sampler0, texCoord0 + vec2(16.0/texSize.x, -8.0/texSize.y));
        //calculate timing
        vec2 duration = vec2(Times.r * 25.5, Times.g * 25.5);
        float time = mod(GameTime * 1200, duration.x + duration.y);
        if (Times.b > 0) { //blend color if interpolate
            float progress = (time <= duration.y)? ((time) / duration.y)-1. : (time - duration.y) / duration.x;
            color = mix(color2, color, (progress + 1.) / 2.);
        }
        else { //no interpolation
            color = (time < duration.y)? color2 : color;
        }
    }
    if (color.a < 0.1) {
        discard;
    }
    color *= vertexColor * ColorModulator;
    color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
    color *= lightMapColor;
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}