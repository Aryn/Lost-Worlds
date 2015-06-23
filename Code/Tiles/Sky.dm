/turf/sky
	layer = 0.5
	name = "Sky"
	icon = 'Icons/World/Sky.dmi'

/turf/sky/New()
	. = ..()
	icon_state = "hover [x%3],[y%3]"

/turf/sky/pure

/hook/game_start/proc/UpdateSkies()
	world << "\green Updating Sky..."
	for(var/turf/sky/S)
		S.UpdateSky()
	return 1

/tile/var/shows_sky = FALSE

/turf/sky/proc/UpdateSky()
	if(type == /turf/sky/pure) return
	if(top && !top.shows_sky) return
	var/turf/B = locate(x,y,z-1)
	if(!B) return
	if(B.top)
		var/icon/I = icon(B.top.icon, B.top.icon_state)
		I.SetIntensity(0.2,0.3,0.4)
		overlays += I

		var/image/over = image('Icons/World/Sky.dmi', icon_state="add [x%3],[y%3]", layer=2)
		overlays += over

proc/ChangeSkyState(state)
	for(var/turf/sky/S)
		if(state) S.icon_state = "[state] [S.x%3],[S.y%3]"
		else S.icon_state = "[S.x%3],[S.y%3]"

turf/sky/Entered(atom/movable/M)
	if(!top)
		if(!M.fall_immune)
			spawn(2) M.Fall(locate(x,y,z-1))

turf/sky/pure/Entered(atom/movable/M)
	if(!top)
		if(!M.fall_immune)
			spawn(2) M.Fall()

atom/movable/var/fall_immune = 0
atom/movable/proc/Fall(turf/T)
	if(T)
		ForceMove(T)
	else
		Erase()

character/Fall(turf/T)
	if(T) . = ..()
	stun(3)
	if(client) client.HShake(4)

tile/Fall(turf/T)
	return

structure/Fall(turf/T)
	if(is_anchored) return
	else return ..()

/turf/map_edge
	layer = 0.5
	mouse_opacity = 0
	icon = 'Icons/World/Blank.dmi'
	opacity = 1
	density = 1