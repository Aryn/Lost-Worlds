#define TESTING

#ifndef TESTING
	#define ASSERT(X)
	#define erase(X) (istype((X),/atom/movable) ? erase(X) : CRASH("erase(): [X] is not a movable atom.")(
#endif

#define true 1
#define false 0

#define PI 3.1415926
#define PI_OVER_2 1.5708
#define PI_OVER_4 0.7854
#define INFINITY 1.#INF
#define NEG_INFINITY -1.#INF

#define FPS 20

#define MINUTES(X) ((X)*60*FPS)
#define SECONDS(X) ((X)*FPS)
#define HOURS(X) ((X)*3600*FPS)

#define BORDER SetLight(5,outside_light-1)

#define MAT_ADD 0
#define MAT_MUL 1
#define MAT_XOR 2

//Skills
#define NOSKILLS 0
#define LEADERSHIP 1
#define MECHANICS 2
#define MEDICINE 4
#define SCIENCE 8
#define LABOUR 16
#define COMBAT 32

//Fighting
#define NONE 0
#define SEARCHING 1
#define INCLUDE_SHIELD 1
