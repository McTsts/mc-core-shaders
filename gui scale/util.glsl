// get gui pixel
/**
The idea behind this.

0) The formula to convert a position from gui space to screen space provided by vanilla
ProjMat * ModelViewMat * vec4(Position, 1.0)

1) Using this you convert 2 spots, 1 pixel apart on each axis from gui space to screen space (by substituting Position). The difference of those is the size of a gui pixel in screen space. 
A factor is necessary because shaders use different grid sizes (different scales)
(ProjMat * ModelViewMat * vec4(vec3(1.0,1.0,0.0), 1.0)).xy - (ProjMat * ModelViewMat * vec4(vec3(0.0,0.0,0.0), 1.0)).xy / <factor>

1.5) Simplifies to:
(ProjMat * ModelViewMat * vec4(1.0,1.0,0.0,1.0)).xy - (ProjMat * ModelViewMat * vec4(0.0,0.0,0.0,1.0)).xy / <factor>

2) All that ModelViewMat does is scaling, so by removing it the factor is also removed. A division by 2 is still necessary, because screen space is [-1;-1] instead of [0;1]
vec2 pixel = ((ProjMat * vec4(vec3(1.0,1.0,0.0), 1.0)).xy - (ProjMat * vec4(vec3(0.0,0.0,0.0), 1.0)).xy) / 2.0;

3) Matrix multiplication is distributive so the formula can be changed to:
vec2 pixel = (ProjMat * (vec4(1, 1, 0, 1) - vec4(0, 0, 0, 1))).xy / 2.0;

3.5) Simplifies to:
vec2 pixel = (ProjMat * vec4(1, 1, 0, 0)) / 2.0;

4) ProjMat's first and second column only have a value at [0][0] and [1][1], third and fourth column are irrelevant (multiplied with 0), resulting in:
vec2 pixel = vec2(ProjMat[0][0], ProjMat[1][1]) / 2.0;

**/
vec2 guiPixel(mat4 ProjMat) {
	return vec2(ProjMat[0][0], ProjMat[1][1]) / 2.0;
}
/**
the resulting value is the size of a gui pixel in screen space,
so you can do something like "gl_Position.x += guiPixel(ProjMat).x" to move a gui element by 1 gui pixel in screen space
**/

/**
From the above we can conclude that ProjMat[0][0]/2.0 has the size of a gui pixel on the x axis, comparing that to the screen size returns the gui scale.
**/
int guiScale(mat4 ProjMat, vec2 ScreenSize) {
    return int(round(ScreenSize.x * ProjMat[0][0] / 2));
}
