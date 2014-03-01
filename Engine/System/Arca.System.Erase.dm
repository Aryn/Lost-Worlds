
proc/erase(atom/movable/AM)
	AM.Erase()
	AM.loc = null

/*

Erase() - Like Del() but cheaper. BYOND has a garbage collector, use it. This will be called before the obj's loc is set to null.

*/
/atom/movable/proc/Erase()