structure/bed
	name = "Bed"
	icon = 'Icons/Ship/Furniture/Bed.dmi'
	dir = 2

structure/proc/Flip()
	var/matrix/M = transform
	M.Scale(-1,1)
	transform = M
	view() << "[usr] flips the bed!"