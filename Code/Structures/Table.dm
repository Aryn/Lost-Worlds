structure/table
	name = "Table"
	desc = "You can put stuff on it. Is anyone under there?"
	icon = 'Icons/Ship/Furniture/Table.dmi'
	icon_state = "0"
	density = 1

	commands = list(
	new/command("Hide", NORMAL, "Crawl under the table and hide.")
	)
	command_icon = 'Icons/Commands/Concealment.dmi'

	var/auto_dir = 0

structure/table/AppliedBy(character/C, item/I)
	I.Drop(loc)
	return TRUE

structure/table/proc/Join()
	auto_dir = 0
	for(var/d = 1, d < 16, d*=2)
		var/structure/table/T = locate() in get_step(src,d)
		if(T)
			auto_dir |= d

	icon_state = "[auto_dir]"

structure/table/proc/Hide()
	var/character/C = usr
	if(istype(C) && C.InRangeOf(src))
		if(C.is_hiding) return
		if(C.last_spotted > world.time-50)
			C << "\red You can't hide again, the jig is up."
		C.Hide()
		C.animate_movement = 0 //Ensures that the hide is a jump rather than a weird sliding movement.
		spawn(1)
			C.Move(loc)
			C.animate_movement = 1

structure/table/Examine()
	. = ..()
	var/character/C = usr
	if(istype(C) && C.InRangeOf(src))
		//for(var/structure/table/table in range(1,C)) //Search a fairly broad area.
		var/character/thief = locate() in loc
		if(thief)
			C << "\red [usr] spotted [thief]!"
			thief << "\red [thief] has been spotted!"
			thief.UnHide()
			thief.last_spotted = world.time

structure/table/IsDense(character/C)
	return istype(C) && !C.is_hiding && !(locate(/structure/table) in C.loc)
	//Allows characters to escape the table if they've been spotted.