# Minecraft Core Shader Projects & Utilities

This is a collection of some shader utilities/projects, mostly for personal use, though feel free to use them for your own purposes if you want to. 
No guarantees that any of this is the best solution for anything.

# Modules
A list of all utilities/shaders/things included in this repo.
Some of the modules contain some of [Onnowhere's utility functions](https://github.com/onnowhere/core_shaders).

## Hide Sidebar Numbers

Hides the first number of scores on the sidebar without removing anything else.  
Includes code/ideas from Suso and dragonmaster95.

## Move Hearts

A shader to move the hearts (or other gui elements), made for VALENTINX110.  
A problem here is that you cant directly access the texture using the vertex UV coordinates as they might be barely in another pixel. This can be resolved by offsetting the position by half a pixel depending on the gl_VertexID.

## Skybox Entire Sky

Makes the entire skybox cover the entire sky, to allow rendering of custom skyboxes.  
This is problematic due to the same shader also affecting text highlighting. 

## Simplified Glowing

This is a super simple *post* shader file that makes glowing perform a lot better by removing the blur thing. This can severely increase fps for some computers. (Vanilla glowing is really bad for weaker computers)

## Remove Capes

With the migration thing capes have become a bigger problem than ever before, so here's a shader to remove them. Unfortunately, I couldn't find a good way to remove them so I check the texture. Technically it's probably possible to make a skin that fools this (since players are rendered by the same shader), but it would never happen by coincidence.
The armor shader additionally removes cape elytras.

## Hide Armor Glint

Removes the enchanted effect from armor on entities only. Keeps the enchanted effect for things in inventory.

## Jetpack

This renders a jetpack on the players back. This shader is not intended to be used as is and will not work without some additional things (armor texture, datapack, etc) and is generally just for reference. The code for it is also probably awful. Enjoy.

It's a core shader that moves/resizes the elements of a leather chestplate/upper leggings part (which consist out of 4 cubes around the players torso). Using the normals of those vertices as well as a hardcoded y axis (which needs to be changed if the player is sneaking) it allows moving some of the planes of the armor around locally (apparently this is called TBN space or something). The jetpack only needs 7 planes (some planes are shared by both engines) which still leaves a few for a normal chestplate.

## Skin Effects

This allows players to customize their damage flash color and add blinking to their skin. This is done by setting one pixel to a specific value to enable the effects (#757591 with opacity 187), specifying a blink frame, a pixel which determines the damage flash color (may not be transparent) and a pixel that determines how often the player blinks.

![image](https://user-images.githubusercontent.com/24660095/136426936-cee123e5-1841-4006-b2c1-085d340f2641.png)


## Custom Particles

This allows you to use custom particles by using the item/block particles. Item/blocks with an opacity of 254/255 will not have the random offset those particles usually have. Fill empty space with solid red (with opacity 254), this will be turned into transparency.
