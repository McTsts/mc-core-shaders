/*
 * Created by Onnowhere (https://github.com/onnowhere)
 * Utility functions for Minecraft core vertex shaders
 */

/*
 * Returns the FOV in degrees
 * Calculates using the fact that top/near = tan(theta / 2)
 */
 
float getFOV(mat4 ProjMat) {
    return atan(1.0, ProjMat[1][1]) * 114.591559;
}

/*
 * Returns if rendering in a GUI
 * In the GUI, near is 1000 and far is 3000, so -(far+near)/(far-near) = -2.0
 */
bool isGUI(mat4 ProjMat) {
    return ProjMat[3][2] == -2.0;
}

/*
Added by Ts
*/
#define INV_OFFSET vec4(0.0, 0.0, 0.0, 0.0)

bool isInvViewMat(mat4 ModelViewMat) {
	return ModelViewMat[0] == vec4(1.0,0.0,0.0,0.0) && ModelViewMat[1] == vec4(0.0,1.0,0.0,0.0) && ModelViewMat[2] == vec4(0.0,0.0,-1.0,0.0);
}

bool isInvFOV(mat4 ProjMat) {
	float fov = getFOV(ProjMat);
	return fov >= 180.0 && fov <= 181.0;
}

bool isInvTop(mat4 ModelViewMat, mat4 ProjMat) {
	return isInvFOV(ProjMat) && isGUI(ProjMat);
}

bool isInvTopAlt(mat4 ProjMat) {
	return isInvFOV(ProjMat) && isGUI(ProjMat);
}

bool isInvTopSkull(mat4 ModelViewMat, mat4 ProjMat) {
	return isInvFOV(ProjMat) && isGUI(ProjMat) && ModelViewMat[1][1] > 0.0;
}
