//Substitute for del()
proc/Erase(datum/thing)
	if(thing) thing.Erase()

/datum/proc/Erase()

/atom/movable/Erase()
	tag = null
	if(!Move(null)) loc = null