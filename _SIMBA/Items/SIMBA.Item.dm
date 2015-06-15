/item/parent_type = /obj
/item
	var/item_slot/slot
	var/equip_slot
	var/respects_form = FALSE
	var/equip_layer = 0

/item/proc/OnPickup(item_slot/slot)
/item/proc/OnDrop(atom/newloc, character/user)
/item/proc/OnSwap(item_slot/next)

/item/proc/ApplyTo(atom/A, character/user)

/item/proc/Consume()
	if(slot) slot._Clear()
	Erase()

/item/Operated(character/user)
	var/item_slot/swap = src.slot
	if(user.active_slot.TryEquip(src))
		src.Move(user)
		if(!swap)
			OnPickup(user.active_slot)