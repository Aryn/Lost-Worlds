
/client/var/tmp_eye = FALSE //Set to TRUE if eye resets to mob when you move (cameras, etc.)

mob/Moved()
	. = ..()
	if(client && client.tmp_eye)
		client.SetEye()
		client.tmp_eye = FALSE

//Call this when you want to set the eye to another atom. Call it with null to return to your mob.
/client/proc/SetEye(atom/movable/new_eye)
	ASSERT(!new_eye || istype(new_eye))
	if(new_eye)
		new_eye.AddHost(src)
		eye = new_eye
		UpdateView()
	else
		ASSERT(istype(eye,/atom/movable))
		var/atom/movable/movable_eye = eye
		movable_eye.RemoveHost(src)
		eye = mob
		for(var/turf/T in turfs_in_view)
			T.viewing_clients.Remove(mob)
			if(!T.viewing_clients.len) T.viewing_clients = null

//Works like viewers() but including mobs whose client.eye is not equal to themselves.
proc/Viewers(atom/A, depth)
	var/turf/T = get_turf(A)
	//Include remotely viewing clients if any.
	. = viewers((depth ? depth : world.view),T)
	if(T.viewing_clients)
		for(var/client/C in T.viewing_clients)
			if(!depth || get_dist(T,C.eye) <= depth) . += C

//Clears the turfs-in-view list and rebuilds it using standard view().
/client/proc/UpdateView()
	for(var/turf/T in turfs_in_view)
		if(T.viewing_clients)
			T.viewing_clients.Remove(mob)
			if(!T.viewing_clients.len) T.viewing_clients = null
	turfs_in_view.Cut()
	for(var/turf/T in view(view,eye))
		if(!T.viewing_clients) T.viewing_clients = list(mob)
		else T.viewing_clients.Add(mob)
		turfs_in_view.Add(T)

/atom/movable/var/list/hosting_clients

/atom/movable/proc/AddHost(client/c)
	if(!hosting_clients) hosting_clients = list()
	hosting_clients.Add(c)

/atom/movable/proc/RemoveHost(client/c)
	if(hosting_clients)
		hosting_clients.Remove(c)
		if(!hosting_clients.len) hosting_clients = null

/client/var/list/turfs_in_view = list()

/turf/var/list/viewing_clients

atom/movable/Moved()
	. = ..()
	if(hosting_clients)
		for(var/client/C in hosting_clients)
			C.UpdateView()