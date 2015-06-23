structure/lockable/door
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

	Lock(item/security/lock/lock)
		overlays += 'Icons/Ship/Doors/Lock.dmi'
		src.lock = lock

/structure/lockable/door/metal
	name = "Metal Door"
	icon = 'Icons/Ship/Doors/Iron.dmi'

/structure/lockable/door/glass
	name = "Glass Door"
	icon = 'Icons/Ship/Doors/Glass.dmi'
	opacity = 0
	closed_opacity = 0
	commands = null


structure/lockable/door/proc/Peek()
	var/character/C = usr
	if(istype(C) && C.InRangeOf(src))
		usr.client.SetEye(src)
		usr.client.tmp_eye = TRUE

structure/lockable/door/Bumped(character/C)
	//Yes, it's true, you can't auto-open locked doors without the key in your hand.
	//If SS13 didn't spam ID doors everywhere I wouldn't have to do this.
	if(istype(C) && !blocked_with && (!lock || lock.CanOpen(C)))
		Open()
		C.ForceMove(loc)
		if(C.client) C.client.last_moved = world.time
		return
	if(lock)
		C << "\red The door is locked."
	else if(blocked_with)
		C << "\red The door won't open."
	if(C.client) C.client.last_moved = world.time


structure/lockable/door/Operated(character/C)
	if(blocked_with) C << "\red The door won't open."
	if(!lock || lock.CanOpenWith(C.ItemInSlot("keys")))
		if(!open)
			Open(TRUE)
		else
			Close(TRUE)

structure/lockable/door/Applied(character/C, item/I)
	if(blocked_with) C << "\red The door won't open."
	if(!lock || lock.CanOpenWith(I))
		if(!open)
			Open(TRUE)
		else
			Close(TRUE)

structure/lockable/door/proc/Open(soft = FALSE)
	icon_state = "open"
	flick("opening",src)
	density = 0
	if(closed_opacity) SetOpacity(0)
	Sound('Sounds/Structure/DoorOpen.ogg',soft ? 25 : 60)
	open = TRUE
	if(!soft)
		spawn CloseCheck()

structure/lockable/door/proc/CloseCheck()
	var/time = 50 + (lock ? 50 : 0)
	while(time > 0)
		sleep(10)
		time -= 10
		if(!open) return

	if(!loc || !open) return
	var/stay_open = FALSE
	for(var/atom/A in loc)
		if(A == src) continue
		if(ismob(A) || istype(A,/structure))
			stay_open = TRUE
			break
	if(!stay_open) Close()
	else spawn(50) .()

structure/lockable/door/proc/Close(soft = FALSE)
	icon_state = "closed"
	flick("closing",src)
	density = 1
	if(soft) Sound('Sounds/Structure/DoorCloseSoft.ogg',25)
	else Sound('Sounds/Structure/DoorClose.ogg',60)
	open = FALSE
	if(closed_opacity)
		spawn(2)
			if(loc) SetOpacity(1)