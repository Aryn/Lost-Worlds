/area/layer = 0

//These turfs magically become sky after placing tiles at their location. Defined to make mapping easier.
/turf/mapping
	parent_type = /turf/sky
	name = "MAP ERROR"
	icon = 'Icons/Debug/Marker.dmi'
	var/tile
	var/obj

/turf/mapping/New()
	if(tile) new tile(src)
	if(obj) new obj(src)
	icon = 'Icons/World/Sky.dmi'
	name = "Sky"
	. = ..()

/turf/mapping/floor
	icon = 'Icons/Mapping/Floor.dmi'
	icon_state = "wood"
	tile = /tile/floor

/turf/mapping/wall
	icon = 'Icons/Mapping/Wall.dmi'
	icon_state = "wood"
	tile = /tile/wall

/turf/mapping/floor/metal
	icon_state = "iron"
	tile = /tile/floor/metal

/turf/mapping/wall/metal
	icon_state = "iron"
	tile = /tile/wall/metal

/turf/mapping/supports
	icon = 'Icons/Mapping/Object.dmi'
	icon_state = "supports"
	tile = /tile/support

/turf/mapping/window
	icon = 'Icons/Mapping/Object.dmi'
	icon_state = "window-wood"
	tile = /tile/floor
	obj = /tile/window

/turf/mapping/window/iron
	icon = 'Icons/Mapping/Object.dmi'
	icon_state = "window-iron"
	tile = /tile/floor/metal
	obj = /tile/window/metal

/turf/mapping/frame
	icon = 'Icons/Mapping/Base.dmi'
	icon_state = "wood"
	tile = /tile/floor
	obj = /tile/frame

/turf/mapping/frame/metal
	icon = 'Icons/Mapping/Base.dmi'
	icon_state = "iron"
	tile = /tile/floor/metal
	obj = /tile/frame/metal

/structure/marker
	name = "Marker"
	icon = 'Icons/Debug/Marker.dmi'
	icon_state = "job"
	invisibility = 101
	is_anchored = TRUE

/structure/marker/initial/proc/Initialize()

/mob/Login()
	var/structure/marker/marker = locate() in world
	Move(marker.loc)

structure/marker/light
	name = "Light"
	New()
		. = ..()
		SetLight(2,3)