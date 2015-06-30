structure/lamp
	name = "Lamp"
	icon = 'Icons/Items/Lamp.dmi'
	icon_state = "Map"
	is_anchored = TRUE
	light = new(4,2)
	var/is_lit = TRUE

	New()
		icon_state = "Lit"
		switch(dir)
			if(NORTH) pixel_y = 32
			if(SOUTH) pixel_y = -32
			if(EAST) pixel_x = 32
			if(WEST) pixel_x = -32
		. = ..()

	Operated(mob/M)
		if(is_lit)
			light.Off()
			is_lit = FALSE
			icon_state = "Unlit"
		else
			light.Reset()
			is_lit = TRUE
			icon_state = "Lit"