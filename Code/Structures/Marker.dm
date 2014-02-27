/structure/marker
	icon = 'Icons/Debug/Marker.dmi'
	icon_state = "job"
	invisibility = 101

/mob/Login()
	var/structure/marker/marker = locate() in world
	Move(marker.loc)