world/mob = /mob/login
world/fps = 30
world/view = 7
world/area = /area/outside
world/turf = /turf/sky

/area
	icon = 'Icons/Area/Map.dmi'
	icon_state = "inside"

/area/outside
	icon_state = "outside"
	layer = 9
	mouse_opacity = 0
	is_outside = TRUE
	New()
		. = ..()
		icon = 'Icons/Lighting/SimpleDark.dmi'
		icon_state = "3333"

world/New()
	. = ..()
	CallHook("startup")
	game.Initialize()