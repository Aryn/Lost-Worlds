/turf
	name = "Sky"
	icon = 'Icons/World/Sky.dmi'

/turf/New()
	. = ..()
	icon_state = "[x%3],[y%3]"

//These turfs magically become sky after placing tiles at their location. Defined to make mapping easier.
/turf/mapping
	icon = 'Icons/Debug/Marker.dmi'
	var/tile
	var/obj

/turf/mapping/New()
	new tile(src)
	if(obj) new obj(src)
	icon = 'Icons/World/Sky.dmi'
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

/structure/marker
	name = "Marker"
	icon = 'Icons/Debug/Marker.dmi'
	icon_state = "job"
	invisibility = 101
	is_anchored = true

/structure/marker/erasing/proc/Initialize()

/mob/Login()
	var/structure/marker/marker = locate() in world
	Move(marker.loc)

structure/marker/erasing/cargo_box
	name = "Cargo Box"
	var/data/cargo_box/cargo = "/data/cargo_box/valuables"

	Initialize()
		var/cargo_str = cargo
		cargo = text2path(cargo)
		if(!ispath(cargo))
			log_critical("No such path: [cargo_str]")
		else
			cargo = new cargo()
			cargo.Assemble(loc)

structure/marker/erasing/light_border
	name = "Light Border"
	Initialize()
		var/turf/T = loc
		lighting_controller.AddBorder(T)
		world << "Added border."

structure/marker/light
	name = "Light"
	New()
		. = ..()
		SetLight(2,3)