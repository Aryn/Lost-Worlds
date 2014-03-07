#define TESTING

#ifndef TESTING
	#define ASSERT(X)
	#define erase(X) (istype((X),/atom/movable) ? erase(X) : CRASH("erase(): [X] is not a movable atom.")(
#endif

#define MAP_WARNINGS
