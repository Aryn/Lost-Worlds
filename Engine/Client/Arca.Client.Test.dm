mob/verb/TestClientViewers()
	for(var/mob/M in Viewers(client.eye))
		world << "Viewer: [M]"

mob/verb/TestEye()
	if(client.eye == src)
		client.SetEye(locate(/structure/marker/eye) in world)
	else
		client.SetEye(src)

/structure/marker/eye
	name = "Eye Marker"
	invisibility = 0

client/perspective = EYE_PERSPECTIVE

/structure/marker/player_in_a_box
	icon = 'Icons/Ship/Box.dmi'
	invisibility = 0
	New()
		. = ..()
		new/character/player(src)
