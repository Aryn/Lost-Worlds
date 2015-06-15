structure/door
	name = "Wooden Door"
	icon = 'Icons/Ship/Doors/Wooden.dmi'
	icon_state = "closed"
	is_anchored = TRUE
	opacity = 1
	density = 1

	var/closed_opacity = 1

	commands = list(
	new/command("Peek", NORMAL, "Peek at the other side of a door. Moving cancels the peek.")
	)
	command_icon = 'Icons/Commands/Door.dmi'

	var/open = FALSE
	var/structure/blocked_with
	var/item/security/lock/lock

	proc/Lock(item/security/lock/lock)
		overlays += 'Icons/Ship/Doors/Lock.dmi'
		src.lock = lock

/structure/door/metal
	name = "Metal Door"
	icon = 'Icons/Ship/Doors/Iron.dmi'

/structure/door/glass
	name = "Glass Door"
	icon = 'Icons/Ship/Doors/Glass.dmi'
	opacity = 0
	closed_opacity = 0
	commands = null

/structure/marker/initial/door_lock
	icon = 'Icons/Ship/Doors/Lock.dmi'
	icon_state = "closed"
	var/code = "00000"

	Initialize()
		var/structure/door/door = locate() in loc
		if(door)
			var/item/security/lock/lock = new(door)
			lock.code = code
			door.Lock(lock)


structure/door/proc/Peek()
	var/character/C = usr
	if(istype(C) && C.InRangeOf(src))
		usr.client.SetEye(src)
		usr.client.tmp_eye = TRUE

structure/door/Bumped(character/C)
	if(istype(C) && CanOpen(C.active_slot.item))
		Open()
		C.ForceMove(loc)
		if(C.client) C.client.last_moved = world.time

structure/door/Operated(character/C)
	if(CanOpen(null))
		if(!open)
			Open(TRUE)
		else
			Close(TRUE)

structure/door/Applied(character/C, item/I)
	if(CanOpen(I))
		if(!open)
			Open(TRUE)
		else
			Close(TRUE)

structure/door/proc/CanOpen(item/key)
	if(lock) return istype(key, /item/security/key) && lock.Check(key)
	else return !blocked_with

structure/door/proc/Open(soft = FALSE)
	icon_state = "open"
	flick("opening",src)
	density = 0
	if(closed_opacity) SetOpacity(0)
	Sound('Sounds/Structure/DoorOpen.ogg',soft ? 25 : 60)
	open = TRUE
	if(!soft)
		spawn(50) CloseCheck()

structure/door/proc/CloseCheck()
	if(!loc || !open) return
	var/stay_open = FALSE
	for(var/atom/A in loc)
		if(A == src) continue
		if(ismob(A) || istype(A,/structure))
			stay_open = TRUE
			break
	if(!stay_open) Close()
	else spawn(50) .()

structure/door/proc/Close(soft = FALSE)
	icon_state = "closed"
	flick("closing",src)
	density = 1
	if(soft) Sound('Sounds/Structure/DoorCloseSoft.ogg',25)
	else Sound('Sounds/Structure/DoorClose.ogg',60)
	open = FALSE
	if(closed_opacity)
		spawn(2)
			if(loc) SetOpacity(1)