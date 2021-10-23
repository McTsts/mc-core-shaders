#version 150

#moj_import <fog.glsl>

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

// custom values
flat in int skinEffects;
flat in vec4 data1Color;
flat in vec4 data2Color;
flat in int isFace;

out vec4 fragColor;

void main() {
	// vanilla stuff #1, get pixel from texture, discard if transparent
    vec4 color = texture(Sampler0, texCoord0);
    if (color.a < 0.1) {
        discard;
    }
	
	// replace flash color
	vec4 oColor = overlayColor; // get vanilla flash color
	if(skinEffects == 1 && oColor.r > oColor.g && data1Color.a == 1.0) { // check if skin effects are enabled, flash is happening, and custom flash color is set
		oColor = vec4(data1Color.rgb, oColor.a);
	}
	
	// replace face texture => blinking
	vec2 texSize = textureSize(Sampler0,0);
	if(skinEffects == 1 && isFace == 1 && (0.1 > mod(GameTime * 1200, (data2Color.r * 5.0)) / (data2Color.r * 5.0)) && texCoord0.y < 16.0/texSize.y && data1Color.a == 1.0) {  // check for skin effects enabled, is face, gametime for blinkin, and finally if a timer for blinking is set
		color = texture(Sampler0, texCoord0 + vec2(16.0/texSize.x, -8.0/texSize.y)); //offset from where it reads the texture
	}
	
	// vanilla stuff #2, mix all the colors the proper way
    color *= vertexColor * ColorModulator;
    color.rgb = mix(oColor.rgb, color.rgb, oColor.a);
    color *= lightMapColor;
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
	
}
