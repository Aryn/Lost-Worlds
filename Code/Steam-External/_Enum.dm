#define IS_VALID(N) (N && !(N.status & PIPE_INVALID))
#define PIPE_NORMAL 0
#define PIPE_INVALID 1
#define PIPE_NEED_REBUILD 2
#define PIPE_NEED_UPDATE 4