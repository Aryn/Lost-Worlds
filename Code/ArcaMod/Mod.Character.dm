/character/humanoid/ChangeForm(form_name)
	form = all_forms[form_name]
	for(var/item_slot/slot in item_slots)
		if(slot.item && slot.item.respects_form) slot.OverlayEquipment() //Resets any form equip states.

	overlays -= body
	body = form.body
	overlays += body

/character/humanoid/GetCommandContext()
	//if(combatant) return BATTLE
	return NORMAL

character/var/structure/pulling

character/proc/Pull(structure/struct)
	if(struct.is_anchored) return
	if(pulling == struct) pulling = null
	else pulling = struct

character/Move(turf/newloc)
	var/old_loc = loc
	. = ..()
	if(. && pulling)
		pulling.Move(old_loc)

character/Bump(atom/A)
	if(A == pulling) pulling = null
	. = ..()

var/command/pull_command = new("Pull", ALL, "Pull this object behind your character.")

structure/New()
	if(!is_anchored)
		if(!commands) commands = list(pull_command)
		else commands.Add(pull_command)
	. = ..()

structure/proc/Pull()
	var/character/C = usr
	C.Pull(src)