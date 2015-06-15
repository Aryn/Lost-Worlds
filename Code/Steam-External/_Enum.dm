#define IS_VALID(N) (N && !(N.status & INVALID))
#define NORMAL 0
#define INVALID 1
#define NEED_REBUILD 2
#define NEED_UPDATE 4