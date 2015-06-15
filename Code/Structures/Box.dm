/structure/box
	name = "Crate"
	desc = "A big wooden box full of stuff. Or not, if it's empty."
	density = 1
	icon = 'Icons/Ship/Box.dmi'
	var/open = FALSE
	var/locked = FALSE
	var/nailed = FALSE
	var/destination_tag

	Del()
		world << "<b>Box Erased</b>"
		. = ..()

	Operated(mob/M)
		if(locked)
			M << "\red This box is locked!"
			return
		if(nailed)
			M << "\red This box is nailed shut!"
			return
		if(!open)
			Sound('Sounds/Structure/Creak.ogg',60)
			icon_state = "open"
			open = TRUE
			for(var/item/I in src)
				I.ForceMove(loc)
		else
			Sound('Sounds/Structure/BoxClose.ogg',60)
			for(var/item/I in loc)
				I.ForceMove(src)
			icon_state = ""
			open = FALSE

	Applied(mob/M, item/I)
		if(open)
			I.slot.Drop(loc)

	Bumped(atom/A)
		var/d = get_dir(A,src)
		var/step = get_step(src,d)
		if(step) Move(step)

/structure/box/locked
	locked = TRUE
	icon_state = "locked"

/structure/box/nailed
	nailed = TRUE
	icon_state = "nailed"