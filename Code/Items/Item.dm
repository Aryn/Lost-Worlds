item/New()
	. = ..()
	Shuffle()

item/proc/Shuffle()
	pixel_x = rand(-8,8)
	pixel_y = rand(-8,8)

item/Drop()
	. = ..()
	Shuffle()