#define HOME 1
#define START 2

#define MAP_TICK_SPEED 5
#define LIFE_TICK_SPEED 5

#define MAP_TIMESCALE SECONDS(30) //Amount of time it takes the ship to cross a map grid square.
#define STANDARD_TIMESCALE MINUTES(5)
#define STD_CONVERSION(X) ((X)*(STANDARD_TIMESCALE/MAP_TIMESCALE))