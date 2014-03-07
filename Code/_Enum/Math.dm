#define true 1
#define false 0

#define PI 3.1415926
#define EX 2.7182818 //Constant e defined so as not to interfere with stray temp variables called E.
#define PI_OVER_2 1.5708
#define PI_OVER_4 0.7854
#define INFINITY 1.#INF
#define NEG_INFINITY -1.#INF

#define SQ(X) ((X)*(X))
#define DISTSQ(A,B) (SQ(A) + SQ(B))

#define LOG_100TO255(X) ((X)*2.55)
#define INV_255TO100(X) ((X)/2.55)

#define LOG_RED(X)      round(log(0.03*(X)+1)*118) //Used to keep red levels high in dark skin colors.

#define MINUTES(X) ((X)*600)
#define SECONDS(X) ((X)*10)
#define HOURS(X) ((X)*36000)

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

//HUD
#define HANDS_OFFSET 8