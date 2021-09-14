# Minecraft Core Shader Projects & Utilities

This is a collection of some shader utilities/projects, mostly for personal use, though feel free to use them for your own purposes if you want to. 
No guarantees that any of this is the best solution for anything.

# Modules
A list of all utilities/shaders/things included in this repo.

## Hide Sidebar Numbers

Hides the first number of scores on the sidebar without removing anything else.  
Includes code/ideas from Suso and dragonmaster95.

## Move Hearts

A shader to move the hearts (or other gui elements), made for VALENTINX110.  
A problem here is that you cant directly access the texture using the vertex UV coordinates as they might be barely in another pixel. This can be resolved by offsetting the position by half a pixel depending on the gl_VertexID.

## Skybox Entire Sky

Makes the entire skybox cover the entire sky, to allow rendering of custom skyboxes.  
This is problematic due to the same shader also affecting text highlighting.  
Uses [Onnowhere's isGUI function](https://github.com/onnowhere/core_shaders).

## Simplified Glowing

This is a super simple *post* shader file that makes glowing perform a lot better by removing the blur thing. This can severely increase fps for some computers. (Vanilla glowing is really bad for weaker computers)
