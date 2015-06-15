#define HOME 1
#define START 2

#define MAP_TICK_SPEED 10
#define LIFE_TICK_SPEED 5

#define MAP_TIMESCALE SECONDS(10) //Amount of time it takes the ship to cross a map grid square.
#define STANDARD_TIMESCALE MINUTES(5)
#define STD_CONVERSION(X) ((X)*(STANDARD_TIMESCALE/MAP_TIMESCALE))

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

//Health
#define MAX_HEALTH 100
#define TARGET_NUMBER_PER_DMG 1/15