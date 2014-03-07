/*

Some math procs used by lighting, including ul's fastroot.

*/

#define LIGHT_ICON 'Icons/Lighting/SimpleDark.dmi'
#define LIGHT_STATES 3

#define LIGHTING_READY lighting_controller && lighting_controller.started

#define DISTSQ3(A,B,C) (SQ(A)+SQ(B)+SQ(C))
#define FSQRT(X) (X > fastroot.len ? new_fsqrt(X) : fastroot[(X)+1])
#define MAX_VALUE(X) (X.cached_value < 0 ? X.max_value() : X.cached_value)
#define VALUE_OF(X) ( !X ? 0 : ( X.is_outside ? LIGHTCLAMP(lighting_controller.starlight) : X.lit_value ) )
#define LIGHTCLAMP(x) ( max(0,min(LIGHT_STATES,round(x,1))) )

var/list/fastroot = list(0, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5,
							5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7,
							7, 7)

proc/new_fsqrt(n)
	//world << "Adding [n-fastroot.len] entries to root table."
	for(var/i = fastroot.len, i <= n, i++)
		fastroot += round(sqrt(i))