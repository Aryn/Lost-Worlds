world/mob = /mob/login
world/fps = 20
world/view = "17x17"
world/area = /area/outside

/area/outside
	icon = 'Icons/Lighting/SimpleDark.dmi'
	icon_state = "3333"
	layer = 9
	mouse_opacity = 0
	is_outside = true

world/New()
	. = ..()
	game.Initialize()