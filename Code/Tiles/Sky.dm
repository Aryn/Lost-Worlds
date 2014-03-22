/turf
	layer = 0.5
	name = "Sky"
	icon = 'Icons/World/Sky.dmi'

/turf/New()
	. = ..()
	icon_state = "move [x%3],[y%3]"

/hook/game_start/proc/UpdateSkies()
	world << "\green Updating Sky..."
	for(var/turf/S)
		S.UpdateSky()
	return 1

/tile/var/shows_sky = FALSE

/turf/proc/UpdateSky()
	if(exposed_tile && !exposed_tile.shows_sky) return
	var/turf/B = locate(x,y,z-1)
	if(!B) return
	if(B.exposed_tile)
		var/icon/I = icon(B.exposed_tile.icon, B.exposed_tile.icon_state)
		I.SetIntensity(0.2,0.3,0.4)
		overlays += I

		var/image/over = image('Icons/World/Sky.dmi', icon_state="add [x%3],[y%3]", layer=2)
		overlays += over

turf/Entered(atom/movable/M)
	if(!exposed_tile)
		spawn(2) M.Fall(locate(x,y,z-1))

atom/movable/proc/Fall(turf/T)
	if(T)
		ForceMove(T)
	else
		Erase()

character/Fall(turf/T)
	if(T) . = ..()
	stun(3)
	if(client) client.HShake(4)

structure/Fall(turf/T)
	if(is_anchored) return
	else . = ..()