structure/lamp
	name = "Lamp"
	icon = 'Icons/Items/Lamp.dmi'
	icon_state = "Lit"
	is_anchored = TRUE
	light = new(4,2)
	var/is_lit = TRUE

	Operated(mob/M)
		if(is_lit)
			light.Off()
			is_lit = FALSE
			icon_state = "Unlit"
		else
			light.Reset()
			is_lit = TRUE
			icon_state = "Lit"