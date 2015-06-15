tile/support
	icon = 'Icons/Tiles/Support.dmi'
	shows_sky = TRUE

tile/patch
	icon = 'Icons/Tiles/FloorPatch.dmi'
	icon_state = "wood"
	shows_sky = TRUE
	New()
		. = ..()
		dir = pick(1,2,4,8)

tile/patch/metal
	icon_state = "iron"