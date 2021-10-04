#version 150

#moj_import <light.glsl>
#moj_import <util.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in vec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec2 texCoord1;
out vec4 normal;
flat out vec4 tint;

#define EQ(a,b) (length(a - b) < 0.002)

// converts a local offset into a relative offset, given a normal with x and z rotation, assuming there is no y rotation
vec3 localOffsetY0(vec3 norm, vec3 offset) {
	mat3 localMat; // init the local mat
	localMat[0] = vec3(norm.z * -1.0, 0.0, norm.x); // x axis has x/z switched and z inverted
	localMat[1] = vec3(0.0, 1.0, 0.0); // y axis is default, by definition
	localMat[2] = vec3(norm.x, 0.0, norm.z); // z axis is just forward => the normal
	
	// calculate the offsets based on the input offset and the localMat
	vec3 outOffset = vec3(0.0);
	outOffset = outOffset + offset.x * localMat[0];
	outOffset = outOffset + offset.y * localMat[1];
	outOffset = outOffset + offset.z * localMat[2];
	return outOffset;
}

vec3 correctPosition(int vid, vec3 offset, vec2 sizeGame, vec2 sizeReal, vec3 norm) {
	// the size a pixel should be for player armor, apparently
	float pixel = (1.0/16.0) * 0.945;
	// calculate scale correction vector
	vec2 scaleCorrection = vec2(pixel * sizeReal.x - sizeGame.x, pixel * sizeReal.y - sizeGame.y);
	// initialize the offset
	vec3 posOffset = vec3(0);
	switch(vid) { // adjust for minecraft stretching textures weirdly
		case 0: posOffset = vec3(offset.x, 												offset.y + scaleCorrection.y, 		offset.z); 	break;
		case 1: posOffset = vec3(offset.x + scaleCorrection.x, 		offset.y + scaleCorrection.y, 		offset.z); 	break;
		case 2: posOffset = vec3(offset.x + scaleCorrection.x, 		offset.y, 											offset.z); 	break;
		case 3: posOffset = vec3(offset.x, 												offset.y, 											offset.z); 	break;
	}
	posOffset = localOffsetY0(norm, posOffset); // convert local coordinates into world coordinates
	return posOffset;
}

void main() {
	// vanilla calculation
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
    texCoord0 = UV0;
    texCoord1 = UV1;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
	
	 // seperate light and tint
    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, vec4(1.0)) * sample_lightmap(UV2);
	tint = Color;

	// adjust uv position based on vertex id to access correct pixel on uv
	vec2 offset = vec2(0.0); // init offset
	float pixelX = (1/64.0) / 2.0; // includes the width of the texture
	float pixelY = (1/32.0) / 2.0; // includes the height of the texture
	int vertexID = gl_VertexID % 4; // every plane has 4 vertices
	switch(vertexID) {
		case 0: offset = vec2(-pixelX, pixelY); break;
		case 1: offset = vec2(pixelX, pixelY); break;
		case 2: offset = vec2(pixelX, -pixelY); break;
		case 3: offset = vec2(-pixelX, -pixelY); break;
		default: offset = vec2(0.0); break;
	}
	vec4 color = texture(Sampler0, UV0 + offset); // retrieve vertex's pixel
	
	// check for special behaivor based on color
	if(EQ(color.a, 254/255.0) || EQ(color.a, 253/255.0) ) { // modify vertices for jetpack
		if(getFOV(ProjMat) >= 180) { // detects if the player is being rendered in their inventory
			gl_Position = vec4(0.0); // do not display this plane
			return;
		}
		// get display state
		int jetpackDisplay = 0;
		int jetpackColor = 0;
		if(EQ(tint.rgb, vec3(96.0/255.0, 61.0/255.0, 53.0/255.0))) { jetpackDisplay = 0; jetpackColor = 0; }
		else if(EQ(tint.rgb, vec3(97.0/255.0, 61.0/255.0, 53.0/255.0))) { jetpackDisplay = 1; jetpackColor = 0; }
		else if(EQ(tint.rgb, vec3(68.0/255.0, 153.0/255.0, 153.0/255.0))) { jetpackDisplay = 0; jetpackColor = 1; }
		else if(EQ(tint.rgb, vec3(69.0/255.0, 153.0/255.0, 153.0/255.0))) { jetpackDisplay = 1; jetpackColor = 1; }
		else if(EQ(tint.rgb, vec3(139.0/255.0, 93.0/255.0, 186.0/255.0))) { jetpackDisplay = 0; jetpackColor = 2; }
		else if(EQ(tint.rgb, vec3(140.0/255.0, 93.0/255.0, 186.0/255.0))) { jetpackDisplay = 1; jetpackColor = 2; }
		// get world mat & adjust position + normal
		mat3 WorldMat = getWorldMat(Light0_Direction, Light1_Direction);
		vec3 pos = (inverse(WorldMat) * Position);
		vec3 norm = (inverse(WorldMat) * Normal);
		// init pixel & no z figh
		float pixel = (1.0/16.0) * 0.945;
		float noZfight = 0.0015;
		float layerOffset = 0.0305;
		// init offset
		vec3 posOffset = vec3(0);
		// detect face
		if(jetpackDisplay != 1 && (EQ(color, vec4(0.0, 0.0, 0.0, 254.0/255.0)) || EQ(color, vec4(0.0, 0.0, 0.0, 253.0/255.0)))) { // remove top while not sneaking
			gl_Position = vec4(0.0); // do not display this plane
			return;
		} if(jetpackDisplay != 0 && (EQ(color, vec4(1.0/255.0, 0.0, 0.0, 254.0/255.0)) && EQ(color, vec4(1.0/255.0, 0.0, 0.0, 253.0/255.0)))) { // remove front & back while sneaking
			gl_Position = vec4(0.0); // do not display this plane
			return;
		} else if(EQ(color, vec4(2.0/255.0, 0.0, 0.0, 254.0/255.0))) { // side face right => side face right 
			vec3 offset = vec3(pixel * 4.0, pixel, -pixel * 1); // offset for all vertices of the plane
			vec2 sizeGame = vec2(0.353, 0.826); // size of the initial plane in game
			vec2 sizeReal = vec2(4.0, 12.0); // size it should actually be
			posOffset = correctPosition(vertexID, offset, sizeGame, sizeReal, norm); // calculate the position
		} else if(EQ(color, vec4(3.0/255.0, 0.0, 0.0, 254.0/255.0))) { // side face left => side face left
			vec3 offset = vec3(pixel * -2.0, pixel, -pixel * 1); // offset for all vertices of the plane
			vec2 sizeGame = vec2(0.353, 0.826); // size of the initial plane in game
			vec2 sizeReal = vec2(4.0, 12.0); // size it should actually be
			posOffset = correctPosition(vertexID, offset, sizeGame, sizeReal, norm); // calculate the position
		} else if(EQ(color, vec4(2.0/255.0, 0.0, 0.0, 253.0/255.0))) { // side face right (2) => middle face right
			vec3 offset = vec3(-layerOffset + pixel * 4.0, pixel - layerOffset + noZfight*2, -pixel * 3.0 - layerOffset + noZfight*2); // offset for all vertices of the plane
			vec2 sizeGame = vec2(0.29, 0.77); // size of the initial plane in game
			vec2 sizeReal = vec2(4.0, 12.0); // size it should actually be
			posOffset = correctPosition(vertexID, offset, sizeGame, sizeReal, norm); // calculate the position
		} else if(EQ(color, vec4(3.0/255.0, 0.0, 0.0, 253.0/255.0))) { // side face left (2) => middle face left
			vec3 offset = vec3(-layerOffset + pixel * -2.0, pixel - layerOffset + noZfight*2, -pixel * 3.0 - layerOffset + noZfight*2); // offset for all vertices of the plane
			vec2 sizeGame = vec2(0.29, 0.77); // size of the initial plane in game
			vec2 sizeReal = vec2(4.0, 12.0); // size it should actually be
			posOffset = correctPosition(vertexID, offset, sizeGame, sizeReal, norm); // calculate the position
		}  else if(EQ(color, vec4(4.0/255.0, 0.0, 0.0, 254.0/255.0))) { // back face => back face
			vec3 offset = vec3(pixel * 1, pixel * 1, pixel * 2 - noZfight); // offset for all vertices of the plane
			vec2 sizeGame = vec2(0.59, 0.826); // size of the initial plane in game
			vec2 sizeReal = vec2(8.0, 12.0); // size it should actually be
			posOffset = correctPosition(vertexID, offset, sizeGame, sizeReal, norm); // calculate the position
		} else if(EQ(color, vec4(1.0/255.0, 0.0, 0.0, 254.0/255.0)) && jetpackDisplay == 0) { // front face => top faces - NORMAL display state
			vec3 offset = vec3(pixel * 1, -noZfight, pixel * -10); // offset for all vertices of the plane
			vec2 sizeGame = vec2(0.59, 0.826); // size of the initial plane in game
			vec2 sizeReal = vec2(8.0, 12.0); // size it should actually be
			/** SEE correctPosition - but switches y / z manually **/
			// calculate scale correction vector
			vec2 scaleCorrection = vec2(pixel * sizeReal.x - sizeGame.x, pixel * sizeReal.y - sizeGame.y);
			// initialize the offset
			switch(vertexID) { // adjust for minecraft stretching textures weirdly
				case 0: posOffset = vec3(offset.x, 												offset.y + scaleCorrection.y, 		offset.z); 	break;
				case 1: posOffset = vec3(offset.x + scaleCorrection.x, 		offset.y + scaleCorrection.y, 		offset.z); 	break;
				case 2: posOffset = vec3(offset.x + scaleCorrection.x, 		offset.y + pixel * 12, 					offset.z + pixel * 12 ); 	break;
				case 3: posOffset = vec3(offset.x, 												offset.y + pixel * 12, 					offset.z + pixel * 12); 	break;
			}
			posOffset = localOffsetY0(norm, posOffset); // convert local coordinates into world coordinates
		} else if(EQ(color, vec4(1.0/255.0, 0.0, 0.0, 253.0/255.0)) && jetpackDisplay == 0) { // front face (2) => bottom faces - NORMAL display state
			vec3 offset = vec3(layerOffset, pixel * 1 + noZfight*4 + layerOffset, -layerOffset + pixel * -14); // offset for all vertices of the plane
			vec2 sizeGame = vec2(0.533, 0.77); // size of the initial plane in game
			vec2 sizeReal = vec2(8.0, 12.0); // size it should actually be
			/** SEE correctPosition - but switches y / z manually **/
			// calculate scale correction vector
			vec2 scaleCorrection = vec2(pixel * sizeReal.x - sizeGame.x, pixel * sizeReal.y - sizeGame.y);
			// initialize the offset
			switch(vertexID) { // adjust for minecraft stretching textures weirdly
				case 0: posOffset = vec3(offset.x, 												offset.y + scaleCorrection.y - pixel * 12, 		offset.z + pixel * 12); 	break;
				case 1: posOffset = vec3(offset.x + scaleCorrection.x, 		offset.y + scaleCorrection.y - pixel * 12, 		offset.z + pixel * 12); 	break;
				case 2: posOffset = vec3(offset.x + scaleCorrection.x, 		offset.y, 					offset.z); 	break;
				case 3: posOffset = vec3(offset.x, 												offset.y, 					offset.z); 	break;
			}
			posOffset = localOffsetY0(norm, posOffset); // convert local coordinates into world coordinates
		} 
		// sneaking states - these are less precise than the other ones, additionally the textures are skewed
		else if(EQ(color, vec4(0.0/255.0, 0.0, 0.0, 254.0/255.0)) && jetpackDisplay == 1) { // top face => top faces - SNEAKING display state
			vec3 offset = vec3(pixel * 2, pixel * -3.4 - noZfight*3, pixel * -5); // offset for all vertices of the plane
			vec2 sizeGame = vec2(0.7, 0.15); // size of the initial plane in game
			vec2 sizeReal = vec2(8.0, 4.0); // size it should actually be
			posOffset = correctPosition(vertexID, offset, sizeGame, sizeReal, norm); // calculate the position
		} else if(EQ(color, vec4(0.0/255.0, 0.0, 0.0, 253.0/255.0)) && jetpackDisplay == 1) { // top face (2) => bottom faces - SNEAKING display state
			vec3 offset = vec3(-layerOffset + pixel * 1.5, pixel * -11.6 + layerOffset - noZfight*3, pixel * -17); // offset for all vertices of the plane
			vec2 sizeGame = vec2(0.6, 0.15); // size of the initial plane in game
			vec2 sizeReal = vec2(8.0, 4.0); // size it should actually be
			posOffset = correctPosition(vertexID, offset, sizeGame, sizeReal, norm); // calculate the position
		} 
		
		// final calculations
		
		// determine the color of the jetpack
		vec4 jColor = vec4(1.0);
		switch(jetpackColor) {
			case 0: jColor = vec4(96.0/255.0, 61.0/255.0, 53.0/255.0, 1.0); break;
			case 1: jColor = vec4(68.0/255.0, 153.0/255.0, 153.0/255.0, 1.0); break;
			case 2: jColor = vec4(139.0/255.0, 93.0/255.0, 186.0/255.0, 1.0); break;
			default: jColor = vec4(1.0, 1.0, 1.0, 1.0); break;
		}
		// output tint 
		tint = jColor;
		// recalculate vanilla value
		gl_Position = ProjMat * ModelViewMat * vec4(WorldMat * (pos + posOffset), 1.0); // converts relative coordinates into world coordinates again
	}
	
}
