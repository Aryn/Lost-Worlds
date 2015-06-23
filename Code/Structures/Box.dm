/structure/lockable/box
	name = "Crate"
	desc = "A big wooden box full of stuff. Or not, if it's empty."
	density = 1
	icon = 'Icons/Ship/Box.dmi'
	var/open = FALSE
	var/item/security/lock/lock
	var/nailed = FALSE
	var/destination_tag

	Del()
		world << "<b>Box Erased</b>"
		. = ..()

	Operated(mob/M)
		if(!open)
			if(nailed)
				M << "\red This box is nailed shut!"
			else if(lock && !lock.CanOpen(M))
				M << "\red This box is locked!"
			else
				Open()
		else
			Close()

	proc/Open()
		Sound('Sounds/Structure/Creak.ogg',60)
		icon_state = "open"
		open = TRUE
		for(var/item/I in src)
			I.ForceMove(loc)
	proc/Close()
		Sound('Sounds/Structure/BoxClose.ogg',60)
		for(var/item/I in loc)
			I.ForceMove(src)
		icon_state = ""
		open = FALSE

	Applied(mob/M, item/I)
		if(!open)
			if(nailed)
				M << "\red This box is nailed shut!"
			else if(lock && !lock.CanOpenWith(I))
				M << "\red This box is locked!"
			else
				Open()
		else if(open)
			I.slot.Drop(loc)

	Bumped(atom/A)
		var/d = get_dir(A,src)
		var/step = get_step(src,d)
		if(step) Move(step)

	Lock(item/security/lock/lock)
		overlays += 'Icons/Ship/BoxLock.dmi'
		src.lock = lock

/structure/lockable/box/nailed
	nailed = TRUE
	icon_state = "nailed"