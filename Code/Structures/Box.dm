/structure/box
	name = "Crate"
	desc = "A big wooden box full of stuff. Or not, if it's empty."
	density = 1
	icon = 'Icons/Ship/Box.dmi'
	var/open = false
	var/locked = false
	var/nailed = false

	OperatedBy(mob/M)
		if(locked)
			M << "\red This box is locked!"
			return
		if(nailed)
			M << "\red This box is nailed shut!"
			return
		if(!open)
			Sound('Sounds/Structure/Creak.ogg',60)
			icon_state = "open"
			open = true
			for(var/item/I in src)
				I.Move(loc)
		else
			Sound('Sounds/Structure/BoxClose.ogg',60)
			for(var/item/I in loc)
				I.Move(src)
			icon_state = ""
			open = false

	AppliedBy(mob/M, item/I)
		if(open)
			I.Drop(loc)

/structure/box/locked
	locked = true
	icon_state = "locked"

/structure/box/nailed
	nailed = true
	icon_state = "nailed"