#define TESTING

#ifndef TESTING
	#define ASSERT(X)
	#define Erase(X) (istype((X),/atom/movable) ? Erase(X) : CRASH("Erase(): [X] is not a movable atom.")(
#endif

#define MAP_WARNINGS
