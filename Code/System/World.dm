world/mob = /mob/login
world/fps = 20
world/view = "17x17"
world/area = /area/outside

/area/outside
	icon = 'Icons/Lighting/SimpleDark.dmi'
	icon_state = "2222"
	layer = 9
	mouse_opacity = 0
	is_outside = TRUE

world/New()
	. = ..()
	CallHook("startup")
	game.Initialize()