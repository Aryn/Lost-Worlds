/item/parent_type = /obj
/item
	var/item_slot/slot
	var/equip_slot
	var/respects_form = FALSE

/item/proc/OnDrop(atom/newloc, character/user)

/item/proc/Consume()
	if(slot) slot._Clear()
	Erase()