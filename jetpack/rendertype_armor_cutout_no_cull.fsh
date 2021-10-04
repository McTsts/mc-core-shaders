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
in vec2 texCoord1;
in vec4 normal;
flat in vec4 tint;

out vec4 fragColor;


#define EQ(a,b) (length(a - b) < 0.002)

vec4 jetpackSideBase(ivec2 uv) {
	vec4 jColor = vec4(0.0);
	// basic rows
	if(uv.y == 21) jColor = vec4(196.0/255.0, 196.0/255.0, 196.0/255.0, 1.0) * tint; // top row gray
	else if(uv.y == 22) jColor = vec4(95.0/255.0, 95.0/255.0, 95.0/255.0, 1.0); // 2nd top row dark gray
	else if(uv.y == 23 || uv.y == 26 || uv.y == 28) jColor = vec4(217.0/255.0, 217.0/255.0, 217.0/255.0, 1.0) * tint; // rows that primarily have that light gray
	else if(uv.y == 27) jColor = vec4(189.0/255.0, 189.0/255.0, 189.0/255.0, 1.0) * tint; // slightly darker stripe through light gray
	else if(uv.y == 29) jColor = vec4(95.0/255.0, 95.0/255.0, 95.0/255.0, 1.0); // 2nd from bottom dark gray
	else if(uv.y == 30) jColor = vec4(81.0/255.0, 81.0/255.0, 81.0/255.0, 1.0); // bottom darker gray
	else jColor = vec4(1.0) * tint; // fill with white
	return jColor;
}

vec4 jetpackSideDetail(ivec2 uv, int offset, vec4 color) {
	vec4 jColor = vec4(0.0);
	// add details
	if(uv.x == offset && uv.y == 23) jColor = vec4(1.0) * tint; // top middle white
	else if(uv.x == offset && (uv.y == 26 || uv.y == 28)) jColor = vec4(1.0) * tint; // bottom middle whites
	else if(uv.x == offset && uv.y == 27) jColor = vec4(217.0/255.0, 217.0/255.0, 217.0/255.0, 1.0) * tint; // bottom middle light gray
	else if(uv.x == offset && uv.y == 29) jColor = vec4(113.0/255.0, 113.0/255.0, 113.0/255.0, 1.0); // bottom middle gray
	else if(uv.x == offset && uv.y == 30) jColor = vec4(99.0/255.0, 99.0/255.0, 99.0/255.0, 1.0); // bottom middle dark gray
	else jColor = color; // fill with previous
	return jColor;
}

vec4 jetpackSide(ivec2 uv, int offset) {
	vec4 color = vec4(0.0);
	color = jetpackSideBase(uv);
	color = jetpackSideDetail(uv, offset, color);
	return color;
}

void main() {
	// get pixel
	vec4 color = texture(Sampler0, texCoord0);

	// discard if transparent (vanilla)
    if(color.a < 0.1) {
        discard;
    } else if(EQ(color.a, 254.0/255.0) || EQ(color.a, 253.0/255.0)) { // jetpack
		vec4 jColor = vec4(0.0);
		if(EQ(color.ra, vec2(4.0/255.0, 254.0/255.0))) { // back face
			ivec2 uv = ivec2(int(floor(texCoord0.x * 64.0)), int(floor(texCoord0.y * 32.0))); // convert the uv into int coordinates
			if(uv.x == 35 || uv.x == 36 || uv.y <= 20 || uv.y >= 31) { // hide parts of the texture that are not meant to be visible
				discard;
			} else { // "Texture"
				jColor = jetpackSideBase(uv);
				jColor = jetpackSideDetail(uv, 33, jColor);
				jColor = jetpackSideDetail(uv, 38, jColor);
			}
		} else if(EQ(color.ra, vec2(1.0/255.0, 254.0/255.0))) { // top face
			ivec2 uv = ivec2(int(floor(texCoord0.x * 64.0)), int(floor(texCoord0.y * 32.0))); // convert the uv into int coordinates
			if(uv.y <= 21 || uv.y >= 25 || uv.x == 23 || uv.x == 24) { // hide parts of the texture that are not meant to be visible
				discard;
			} else { // "Texture"
				if(uv.y == 23 && (uv.x == 21 || uv.x == 26)) jColor = vec4(1.0, 1.0, 1.0, 1.0) * tint; // white dot in the middle
				else jColor = vec4(196.0/255.0, 196.0/255.0, 196.0/255.0, 1.0) * tint; // surrounding gray
			}
		} else if(EQ(color.ra, vec2(1.0/255.0, 253.0/255.0))) { // bottom face
			ivec2 uv = ivec2(int(floor(texCoord0.x * 64.0)), int(floor(texCoord0.y * 32.0))); // convert the uv into int coordinates
			if(uv.y <= 21 || uv.y >= 25 || uv.x == 23 || uv.x == 24) { // hide parts of the texture that are not meant to be visible
				discard;
			} else { // "Texture"
				if(uv.y == 23 && (uv.x == 21 || uv.x == 26)) jColor = vec4(1.0, 197.0/255.0, 104.0/255.0, 1.0); // brightest orange in the middle
				else if(uv.y == 23 || uv.x == 21 || uv.x == 26) jColor = vec4(1.0, 161.0/255.0, 0.0, 1.0); // less bright orange
				else jColor = vec4(1.0, 123.0/255.0, 0.0, 1.0); // darkest orange in the corners
			}
		} else if(EQ(color.ra, vec2(2.0/255.0, 254.0/255.0))) { // side face right
			ivec2 uv = ivec2(int(floor(texCoord0.x * 64.0)), int(floor(texCoord0.y * 32.0))); // convert the uv into int coordinates
			if(uv.x >= 19 || uv.y <= 20 || uv.y >= 31) { // hide parts of the texture that are not meant to be visible
				discard;
			} else { // "Texture"
				jColor = jetpackSide(uv, 17);
			}
		} else if(EQ(color.ra, vec2(3.0/255.0, 254.0/255.0))) { // side face left
			ivec2 uv = ivec2(int(floor(texCoord0.x * 64.0)), int(floor(texCoord0.y * 32.0))); // convert the uv into int coordinates
			if(uv.x <= 28 || uv.y <= 20 || uv.y >= 31) { // hide parts of the texture that are not meant to be visible
				discard;
			} else { // "Texture"
				jColor = jetpackSide(uv, 30);
			}
		} else if(EQ(color.ra, vec2(2.0/255.0, 253.0/255.0))) { // middle face right
			ivec2 uv = ivec2(int(floor(texCoord0.x * 64.0)), int(floor(texCoord0.y * 32.0))); // convert the uv into int coordinates
			if(uv.x >= 19 || uv.y <= 20 || uv.y >= 31) { // hide parts of the texture that are not meant to be visible
				discard;
			} else { // "Texture"
				jColor = jetpackSide(uv, 17);
			}
		} else if(EQ(color.ra, vec2(3.0/255.0, 253.0/255.0))) { // middle face left
			ivec2 uv = ivec2(int(floor(texCoord0.x * 64.0)), int(floor(texCoord0.y * 32.0))); // convert the uv into int coordinates
			if(uv.x <= 28 || uv.y <= 20 || uv.y >= 31) { // hide parts of the texture that are not meant to be visible
				discard;
			} else { // "Texture"
				jColor = jetpackSide(uv, 30);
			}
		}  else if(EQ(color.ra, vec2(0.0/255.0, 254.0/255.0))) { // top face alt 
			ivec2 uv = ivec2(int(floor(texCoord0.x * 64.0)), int(floor(texCoord0.y * 32.0))); // convert the uv into int coordinates
			if(uv.x == 23 || uv.x == 24 || uv.y >= 18) { // hide parts of the texture that are not meant to be visible
				discard;
			} else { // "Texture"
				jColor = vec4(196.0/255.0, 196.0/255.0, 196.0/255.0, 1.0) * tint; // surrounding gray
			}
		}   else if(EQ(color.ra, vec2(0.0/255.0, 253.0/255.0))) { // bottom face alt 
			ivec2 uv = ivec2(int(floor(texCoord0.x * 64.0)), int(floor(texCoord0.y * 32.0))); // convert the uv into int coordinates
			if(uv.x == 23 || uv.x == 24 || uv.y >= 18) { // hide parts of the texture that are not meant to be visible
				discard;
			} else { // "Texture"
				jColor = vec4(1.0, 161.0/255.0, 0.0, 1.0);
			}
		} else { // no face
			jColor = vertexColor; // this shouldn't visibly happen
		}
		fragColor = jColor * vertexColor * ColorModulator;
	} else { // output color normally (vanilla)
		fragColor = color * vertexColor * ColorModulator;
	}

}
