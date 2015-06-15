/character/parent_type = /mob

/character/var/list/item_slots
/character/var/item_slot/active_slot
/character/var/character_form/form

/character/proc/ItemSlot(slot_name)
/character/proc/ChangeActiveSlot()

/character/proc/GetCommandContext()
	return ALL

//Returns TRUE if the character is in close range, FALSE if character must use ranged proc variations.
/character/proc/InRangeOf(atom/movable/A)
	return A.loc == src || src.loc == A || get_dist(src,A) <= 1

/character/proc/ChangeForm(new_form)
	form = new_form
	for(var/item_slot/slot in item_slots)
		if(slot.item && slot.item.respects_form) slot.OverlayEquipment() //Resets any form equip states.


/character_form
	var/name = "default"