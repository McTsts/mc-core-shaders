# Minecraft Core Shader Projects & Utilities

This is a collection of some shader utilities/projects, mostly for personal use, though feel free to use them for your own purposes if you want to. 
No guarantees that any of this is the best solution for anything.
If you want to use any of the things listed on here, but are not sure how to use them / edit them for what you need, let me know on discord (@mctsts), on the [crowdford server](https://discord.gg/qZ3SCcc) or create an issue on this repo.

# Modules
A list of all utilities/shaders/things included in this repo. I started listing versions on newer ones, but they may still work in newer or older version, it's simply the most recent release I've tested it in.

### Useful Shaders
*You can probably use these for your own maps*  
- [Hide Sidebar Numbers](#hide-sidebar-numbers)
- [Move Hearts](#move-hearts)
- [Skybox Entire Sky](#skybox-entire-sky)
- [Simplified Glowing](#simplified-glowing)
- [Remove Capes](#remove-capes)
- [Hide Armor Glint](#hide-armor-glint)
- [Skin Effects](#skin-effects)
- [Custom Particles](#custom-particles)
- [Wavy Water](#wavy-water)
- [Remove Nameboxes](#remove-name-boxes)
- [Move Enchanting Table GUI book](#move-enchanting-table-gui-book)
- [Move Inventory Player](#move-inventory-player)
- [Move XP Number](#move-xp-number)
- [GUI Scale](#gui-scale)
- [Hardcore Hearts](#hardcore-hearts)
- [Remove Text Shadow](#remove-text-shadow)

### Reference Shaders
*These are mainly here as examples and reference, and you probably won't be able to use these yourself*
- [Jetpack](#jetpack)

## Hide Sidebar Numbers
[1.19.2]

Hides the first number of scores on the sidebar without removing anything else.  
Includes code/ideas from Suso and dragonmaster95.

[Back](#modules)

## Move Hearts
[1.19.4]

A shader to move the hearts (or other gui elements), made for VALENTINX110.  
A problem here is that you cant directly access the texture using the vertex UV coordinates as they might be barely in another pixel. This can be resolved by offsetting the position by half a pixel depending on the gl_VertexID.

[Back](#modules)

## Skybox Entire Sky

Makes the entire skybox cover the entire sky, to allow rendering of custom skyboxes.  
This is problematic due to the same shader also affecting text highlighting.

[Back](#modules) 

## Simplified Glowing

This is a super simple *post* shader file that makes glowing perform a lot better by removing the blur thing. This can severely increase fps for some computers. (Vanilla glowing is really bad for weaker computers)

[Back](#modules)

## Remove Capes

With the migration thing capes have become a bigger problem than ever before, so here's a shader to remove them. Unfortunately, I couldn't find a good way to remove them so I check the texture. Technically it's probably possible to make a skin that fools this (since players are rendered by the same shader), but it would never happen by coincidence.
The armor shader additionally removes cape elytras.

[Back](#modules)

## Hide Armor Glint

Removes the enchanted effect from armor on entities only. Keeps the enchanted effect for things in inventory.

[Back](#modules)

## Jetpack

This renders a jetpack on the players back. This shader is not intended to be used as is and will not work without some additional things (armor texture, datapack, etc) and is generally just for reference. The code for it is also probably awful. Enjoy.

It's a core shader that moves/resizes the elements of a leather chestplate/upper leggings part (which consist out of 4 cubes around the players torso). Using the normals of those vertices as well as a hardcoded y axis (which needs to be changed if the player is sneaking) it allows moving some of the planes of the armor around locally (apparently this is called TBN space or something). The jetpack only needs 7 planes (some planes are shared by both engines) which still leaves a few for a normal chestplate.

[Back](#modules)

## Skin Effects

This allows players to customize their damage flash color and add blinking to their skin. This is done by setting one pixel to a specific value to enable the effects (#757591 with opacity 187), specifying a blink frame, a pixel which determines the damage flash color (may not be transparent) and a pixel that determines how often the player blinks.

![image](https://user-images.githubusercontent.com/24660095/136426936-cee123e5-1841-4006-b2c1-085d340f2641.png)

[Back](#modules)


## Custom Particles

This allows you to use custom particles by using the item/block particles. Item/blocks with an opacity of 254/255 will not have the random offset those particles usually have. Fill empty space with solid red (with opacity 254), this will be turned into transparency.

[Back](#modules)

## Wavy Water

This makes water move up and down.  This is adjusted for only two biomes: the void & swamp. Other biomes may not work. Adjust line 35 of the vsh  (the color checks) to make it work elsewhere.

[Back](#modules)

## Remove Name Boxes

This is a very very simple shader, that removes the boxes around names without having to rely on things like negative spaces.

[Back](#modules)

## Move Enchanting Table GUI Book
[1.17.1 - 1.19.4]

Simple shader that allows to move the book in enchanting table gui. Define an offset in `core/rendertype_entity_solid.vsh`, line 35.

Example:

<img src="https://github-production-user-asset-6210df.s3.amazonaws.com/92710569/245508578-ec899466-9ce6-4e3e-b008-e3ef5ddd1adc.png" width=300>

[Back](#modules)

## Move Inventory Player
[1.18.2 - 1.19.4]

This is a bunch of shaders that can move the player that's displayed inside the inventory. It allows you to define an offset in `include\util.glsl`, line 26 that offsets the player and everything attached to it. This works with all GUI scales.

Example:  
<img src="https://user-images.githubusercontent.com/24660095/151046774-9eb092dd-2e09-4c7e-a038-ef4bd7da7d98.png" width=300>

[Back](#modules)

## Move & Recolor XP Number  
[1.18.2]

This is a shader that moves and recolors the xp number with a fairly specific way of isolating it. You can remove the move or color part easily if you only want the other one.

Example:  
<img src="https://user-images.githubusercontent.com/24660095/160714806-0fde1e77-fd18-47c3-ada2-ffd12f7025ed.png" width=300>

[Back](#modules)

## GUI Scale
[1.18.2]

A utility function that helps with dealing with GUI scales. 

[Back](#modules)

## Hardcore Hearts 
[1.18.2 - 1.20]

Replaces hearts with heardcore hearts, without affecting the `icons.png` texture. Also does it in tab. Also works for the heart variants like wither, frozen, absorption, etc.

<img src="https://user-images.githubusercontent.com/24660095/163684262-5bd4eb3c-92e7-4e22-8b26-c3d9fa8c789e.png" width=150><img src="https://user-images.githubusercontent.com/24660095/163684266-7f09432f-d45f-45cf-8407-4c784ee8904d.png" width=150>

[Back](#modules)

## Remove Text Shadow 
[1.19]

Removes the shadow of texts. Only applies for characters with an opacity of 254, so it can be used to hide the shadows of e.g. icons. Also only affects text located at depth 0 (which is most text, such as e.g. bossbars). A list of text depths can be found [here](https://github.com/McTsts/Minecraft-Shaders-Wiki/blob/main/Core%20Shader%20List.md#text).

[Back](#modules)



