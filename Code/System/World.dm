world/mob = /mob/login
world/fps = 30
world/view = 7
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