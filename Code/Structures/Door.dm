structure/door
	name = "Wooden Door"
	icon = 'Icons/Ship/Doors/Wooden.dmi'
	icon_state = "closed"
	is_anchored = true
	opacity = 1
	density = 1

	commands = list(
	"Peek" = "Peek at the other side of the door. Moving cancels the peek."
	)
	command_icon = 'Icons/Commands/Door.dmi'

	var/open = false
	var/structure/blocked_with

/structure/door/metal
	name = "Metal Door"
	icon = 'Icons/Ship/Doors/Iron.dmi'

structure/door/proc/Peek()
	var/character/C = usr
	if(istype(C) && C.InRangeOf(src))
		usr.client.SetEye(src)
		usr.client.tmp_eye = true

structure/door/Bumped(character/C)
	if(!blocked_with && istype(C))
		Open()
		C.ForceMove(loc)
		if(C.client) C.client.last_moved = world.time

structure/door/OperatedBy(character/C)
	if(!blocked_with)
		if(!open)
			Open(true)
		else
			Close(true)

structure/door/proc/Open(soft = false)
	icon_state = "open"
	flick("opening",src)
	density = 0
	SetOpacity(0)
	Sound('Sounds/Structure/DoorOpen.ogg',soft ? 25 : 60)
	open = true
	if(!soft)
		spawn(50) CloseCheck()

structure/door/proc/CloseCheck()
	if(!loc || !open) return
	var/stay_open = false
	for(var/atom/A in loc)
		if(A == src) continue
		if(ismob(A) || istype(A,/structure))
			stay_open = true
			break
	if(!stay_open) Close()
	else spawn(50) .()

structure/door/proc/Close(soft = false)
	icon_state = "closed"
	flick("closing",src)
	density = 1
	if(soft) Sound('Sounds/Structure/DoorCloseSoft.ogg',25)
	else Sound('Sounds/Structure/DoorClose.ogg',60)
	open = false
	spawn(2)
		if(loc) SetOpacity(1)