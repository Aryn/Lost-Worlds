//A tile is very similar to a turf, but is far faster and less hazardous to change or replace, being derived from /obj.
/tile/parent_type = /obj
/tile/layer = 2


/* MOVEMENT HANDLING */
/tile/proc/StepOn(atom/movable/movable)
	src.SteppedOn(movable)
	return 1

/tile/proc/StepOff(atom/movable/movable)
	src.SteppedOff(movable)
	return 1

/tile/proc/SteppedOn(atom/movable/movable)
/tile/proc/SteppedOff(atom/movable/movable)

/turf/var/tile/top

/turf/proc/_ResetTop(tile/exclude)

	//Reset the top tile by "adding" every tile. The top will be correct after all tiles are re-added.
	//This takes O(n) time, but the contents list is hopefully smaller than hundreds of items or you have bigger problems.
	top = null
	for(var/tile/tile in src.contents)
		if(tile == exclude) continue
		src._AddTile(tile)

//Called when a tile is assigned to a turf.
/turf/proc/_AddTile(tile/tile)

	//Overlap any tile with a lower layer.
	if(!top || top.layer <= tile.layer)
		top = tile

/turf/proc/_RemoveTile(tile/tile)

	if(top == tile)
		src._ResetTop(tile)

/turf/Enter(atom/movable/movable, atom/oldloc)
	if(top && !top.StepOn(movable)) return 0
	return ..()

/turf/Exit(atom/movable/movable, atom/newloc)
	if(top && !top.StepOff(movable)) return 0
	return ..()

/* INSERTION HANDLING */

/tile/New(turf/turf)
	if(!isturf(turf)) CRASH("Cannot place tiles within non-space objects.")
	. = ..()
	turf._AddTile(src)

/tile/Move(newloc)
	return 0

/tile/Erase()
	var/turf/turf = loc
	. = ..()
	turf._RemoveTile(src)
