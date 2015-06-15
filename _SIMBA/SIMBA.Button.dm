
/button
	parent_type = /obj
	layer = UI_LAYER
	var/group

/button/proc/Pressed(character/user)

/button/proc/CheckRequirements(character/user)
	return TRUE

/button/Click()
	var/character/user = usr
	if(CheckRequirements(user))
		Pressed(user)

/button/proc/Show(mob/mob)
	if(mob.client)
		mob.client.screen |= src

/button/proc/Hide(mob/mob)
	if(mob.client)
		mob.client.screen -= src