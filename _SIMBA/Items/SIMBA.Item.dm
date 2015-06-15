/item/parent_type = /obj
/item
	var/item_slot/slot
	var/equip_slot
	var/respects_form = FALSE
	var/equip_layer = 0

/item/proc/OnPickup(character/user)
/item/proc/OnDrop(atom/newloc, character/user)
/item/proc/OnSwap(character/user)

/item/proc/ApplyTo(atom/A, character/user)

/item/proc/Consume()
	if(slot) slot._Clear()
	Erase()