
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
		UpdateView()

//Works like viewers() but returns clients, including clients whose eye is not equal to their mob.
proc/ViewingClients(atom/A)
	var/turf/T = GetTurf(A)
	return T.viewing_clients

//Clears the turfs-in-view list and rebuilds it using standard view().
/client/proc/UpdateView()
	for(var/turf/T in turfs_in_view)
		T.RemoveViewer(src)
	turfs_in_view.Cut()
	for(var/turf/T in view(view,eye))
		T.AddViewer(src)
		turfs_in_view.Add(T)

/atom/movable/var/list/hosting_clients

/atom/movable/proc/AddHost(client/c)
	if(!hosting_clients) hosting_clients = list()
	hosting_clients.Add(c)

/atom/movable/proc/RemoveHost(client/c)
	hosting_clients.Remove(c)
	if(!hosting_clients.len) hosting_clients = null

/client/var/list/turfs_in_view = list()

/turf/var/list/viewing_clients

/turf/proc/AddViewer(client/c)
	if(!viewing_clients) viewing_clients = list(c)
	else viewing_clients.Add(c)

/turf/proc/RemoveViewer(client/c)
	viewing_clients.Remove(c)
	if(!viewing_clients.len) viewing_clients = null

mob/Moved()
	. = ..()
	if(client)
		client.UpdateView()


atom/movable/Moved()
	. = ..()
	if(hosting_clients)
		for(var/client/C in hosting_clients)
			C.UpdateView()